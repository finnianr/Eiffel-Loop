note
	description: "Youtube video"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-26 13:53:55 GMT (Wednesday 26th April 2023)"
	revision: "18"

class
	EL_YOUTUBE_VIDEO

inherit
	ANY

	EL_MODULE_FILE_SYSTEM; EL_MODULE_DIRECTORY; EL_MODULE_LIO; EL_MODULE_USER_INPUT

	EL_ZSTRING_CONSTANTS; EL_STRING_8_CONSTANTS

	EL_YOUTUBE_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make (a_url: ZSTRING; a_output_dir: DIR_PATH)
		require
			not_empty: not a_url.is_empty
		do
			make_default
			url := a_url; output_dir := a_output_dir

			lio.put_labeled_string ("Fetching formats for", a_url)
			lio.put_new_line_x2

			if attached Cmd_get_youtube_options as cmd then
				cmd.put_string (Var.url, a_url)
				cmd.execute

				audio_stream_list.fill (cmd.lines)
				video_stream_list.fill (cmd.lines)
			end
		end

	make_default
		do
			create url.make_empty
			create title.make_empty
			create output_dir
			create output_path
			create download_list.make (2)
			create audio_stream_list.make (Maximum_stream_count)
			create video_stream_list.make (Maximum_stream_count)
		end

feature -- Access

	get_output_extension: STRING
		local
			option_list: LIST [STRING]; menu_select: EL_USER_MENU_SELECT
		do
			Result := Empty_string_8
			inspect download_list.count
				when 1 then
					if attached download_list.audio as audio then
						Result := audio.stream.extension
					end

				when 2 then
					if attached download_list.video as video then
						option_list := video.stream.extension_set.to_list
						create menu_select.make ("Select container type", option_list, "Quit")
						menu_select.select_index
						if not option_list.off then
							Result := option_list.item
						end
					end
			else
			end
		end

	title: ZSTRING

	url: ZSTRING

feature -- Measurement

	stream_count: INTEGER
		do
			Result := audio_stream_list.count + video_stream_list.count
		end

feature -- Status query

	downloads_selected: BOOLEAN
		do
			Result := download_list.count > 0
		end

	is_merge_complete: BOOLEAN
		-- `True' if `output_path.exists'
		do
			Result := output_path.exists
		end

feature -- Element change

	set_title (a_title: like title)
		do
			if a_title.is_empty then
				title := default_title
			else
				title := a_title
			end
			across download_list as download loop
				download.item.set_file_path (title, output_dir)
			end
		end

feature -- Basic operations

	download_all (output_extension: STRING)
		locaL
			done: BOOLEAN; audio_path: FILE_PATH
			video_extension: STRING
		do
			from until done loop
				download_list.download_all
				if download_list.exist then
					if attached download_list.video as video_download then
						video_extension := video_download.stream.extension
						if video_extension ~ output_extension then
							merge_streams
						elseif video_extension ~ MP4_extension then
							convert_streams_to_mp4
						end
						if is_merge_complete then
							cleanup
							done := True
						else
							done := not User_input.approved_action_y_n ("Merging of streams failed. Retry?")
						end
					elseif attached download_list.audio as audio_download then
					-- audio only
						audio_path := audio_download.base_output_path
						audio_path.add_extension (audio_download.stream.extension)
						File_system.rename_file (audio_download.file_path, audio_path)
						done := True
					end
				else
					done := not User_input.approved_action_y_n ("Download of streams failed. Retry?")
				end
			end
		end

	select_downloads
		require
			has_streams: stream_count > 0
		local
			quit: BOOLEAN
		do
			download_list.wipe_out
			across stream_list_array as array until quit loop
				if attached array.item as list then
					list.get_user_choice (url, download_list)
					if list.selected_index = 0 then
						download_list.wipe_out
						quit := True
					end
				end
			end
		end

feature {NONE} -- Implementation

	cleanup
		do
			if output_path.exists then
				across download_list as download loop
					download.item.remove
				end
			end
		end

	convert_streams_to_mp4
		require
			valid_downloads: downloads_selected
		do
			if attached download_list.video as video then
				output_path := video.base_output_path
				output_path.add_extension (MP4_extension)
				do_conversion (Cmd_convert_to_mp4, "Converting to")
				lio.put_new_line
			end
		end

	default_title: ZSTRING
		local
			index: INTEGER
		do
			if attached Cmd_get_youtube_file_name as cmd then
				lio.put_labeled_string ("Getting title for", url)
				lio.put_new_line
				lio.put_character ('.')
				cmd.put_string (Var.url, url)
				cmd.execute
				lio.put_new_line
				if cmd.lines.count > 0 then
					Result := cmd.lines.first
					across << '-', '.' >> as c until index > 0 loop
						index := Result.last_index_of (c.item, Result.count)
					end
					if index > 0 then
						Result.keep_head (index - 1)
					end
					lio.put_labeled_string ("Title", Result)
					lio.put_new_line_x2
				else
					Result := "untitled"
				end
			end
		end

	do_conversion (command: EL_OS_COMMAND; description: STRING)
		local
			socket: EL_UNIX_STREAM_SOCKET; progress_display: EL_CONSOLE_PROGRESS_DISPLAY
			pos_out_time: INTEGER; total_duration: DOUBLE; line: STRING; time: TIME
		do
			total_duration := video_duration_fine_seconds
			lio.put_labeled_string (description, output_path.to_string)
			lio.put_new_line

			across download_list as download loop
				download.item.set_command_path (command)
			end

			command.put_path (Var.output_path, output_path)
			command.put_path (Var.socket_path, Socket_path)
			command.put_string (Var.title, title)

			create socket.make_server (Socket_path)
			socket.listen (1)
			socket.set_blocking

			command.set_forking_mode (True)
			command.execute

			socket.accept
			-- Track progress via Unix socket
			if attached {EL_STREAM_SOCKET} socket.accepted as ffmpeg_socket then
				create progress_display.make
				from until ffmpeg_socket.was_error loop
					ffmpeg_socket.read_line
					if ffmpeg_socket.was_error then
						line := ffmpeg_socket.last_string (False)
						pos_out_time := line.substring_index (Out_time_field, 1)
						if pos_out_time > 0 then
							time := new_time (line.substring (pos_out_time + Out_time_field.count, line.count))
							progress_display.set_progress (time.duration.fine_seconds_count / total_duration)
						end
					end
				end
				ffmpeg_socket.close
			end
			socket.close
		end

	merge_streams
		-- merge audio and video streams using same video container
		require
			valid_downloads: downloads_selected
		do
			if attached download_list.video as video then
				output_path := video.base_output_path
				output_path.add_extension (video.file_path.extension)
				do_conversion (Cmd_merge, "Merging audio and video streams to")
				lio.put_new_line
			end
		end

	new_time (time_string: STRING): TIME
		do
			create Result.make_from_string (time_string, once "[0]hh:[0]mi:[0]ss.ff3")
		end

	stream_list_array: ARRAY [EL_YOUTUBE_STREAM_LIST]
		do
			Result := << audio_stream_list, video_stream_list >>
		end

	video_duration_fine_seconds: DOUBLE
		do
			if attached download_list.video as download then
				Cmd_video_duration.put_path (Var.video_path, download.file_path)
				Cmd_video_duration.execute
				if attached Cmd_video_duration.lines.first as first then
					Result := new_time (first.substring_between_general ("Duration: ", ", ", 1)).fine_seconds
				end
			end
		end

feature {NONE} -- Internal attributes

	audio_stream_list: EL_YOUTUBE_AUDIO_STREAM_LIST

	download_list: EL_YOUTUBE_STREAM_DOWNLOAD_LIST

	output_dir: DIR_PATH

	output_path: FILE_PATH

	video_stream_list: EL_YOUTUBE_VIDEO_STREAM_LIST

feature {NONE} -- OS commands

	Cmd_convert_to_mp4: EL_OS_COMMAND
		-- -loglevel info
		once
			create Result.make_with_name (
				"convert_to_mp4", "ffmpeg -i $audio_path -i $video_path%
				% -loglevel quiet -nostats -progress unix:$socket_path%
				% -metadata title=%"$title%"%
				% -movflags faststart -profile:v high -level 5.1 -c:a copy $output_path"
			)
		end

	Cmd_get_youtube_file_name: EL_CAPTURED_OS_COMMAND
		once
			create Result.make_with_name ("get_youtube_file_name", "youtube-dl --get-filename $url")
		end

	Cmd_get_youtube_options: EL_CAPTURED_OS_COMMAND
		once
			create Result.make_with_name ("get_youtube_options", "youtube-dl -F $url")
		end

	Cmd_merge: EL_OS_COMMAND
		once
			create Result.make_with_name (
				"mp4_merge", "ffmpeg -i $audio_path -i $video_path%
				% -loglevel quiet -nostats -progress unix:$socket_path%
				% -metadata title=%"$title%" -c copy $output_path"
			)
		end

	Cmd_video_duration: EL_CAPTURED_OS_COMMAND
		once
			create Result.make_with_name ("get_duration", "ffmpeg -i $video_path 2>&1 | grep Duration")
		end

feature {NONE} -- Constants

	Maximum_stream_count: INTEGER = 10

	Out_time_field: STRING = "out_time="

	Socket_path: FILE_PATH
		once
			Result := Directory.temporary + "el_toolkit-youtube_dl.sock"
		end

end