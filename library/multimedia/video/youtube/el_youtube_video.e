note
	description: "Youtube video"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-24 13:35:45 GMT (Monday 24th April 2023)"
	revision: "17"

class
	EL_YOUTUBE_VIDEO

inherit
	EL_HASH_TABLE [EL_YOUTUBE_STREAM_LIST, STRING]
		rename
			make as make_from_array,
			item as stream_list
		export
			{NONE} all
		end

	EL_ZSTRING_CONSTANTS

	EL_YOUTUBE_CONSTANTS

	EL_MODULE_DIRECTORY

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

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
			Cmd_get_youtube_options.put_string (Var.url, a_url)
			Cmd_get_youtube_options.execute

			across Current as table loop
				table.item.fill (Cmd_get_youtube_options.lines)
			end
		end

	make_default
		do
			create url.make_empty
			create title.make_empty
			create output_dir
			create output_path
			make_from_array (<<
				[Audio, create {EL_YOUTUBE_STREAM_LIST}.make (Audio, 10)],
				[Video, create {EL_YOUTUBE_STREAM_LIST}.make (Video, 10)]
			>>)
		end

feature -- Access

	selected_download: detachable EL_YOUTUBE_STREAM_DOWNLOAD
		-- selected video stream download
		do
			if attached stream_list (Video) as list
				and then attached list.download as download
			then
				Result := download
			end
		end

	selected_extension: STRING
		do
			if attached stream_list (Video) as list and then not list.off then
				Result := list.selected.extension
			else
				create Result.make_empty
			end
		end

	title: ZSTRING

	url: ZSTRING

feature -- Measurement

	stream_count: INTEGER
		do
			across Current as list loop
				Result := Result + list.item.count
			end
		end

feature -- Status query

	downloads_exists: BOOLEAN
		do
			if attached download_list as list and then list.count = 2 then
				Result := across list as download all download.item.exists end
			end
		end

	downloads_selected: BOOLEAN
		do
			Result := download_list.count = 2
		end

	is_merge_complete: BOOLEAN
		-- `True' if `output_path.exists'
		do
			Result := output_path.exists
		end

feature -- Element change

	set_title (a_title: like title)
		do
			title := a_title
			across download_list as download loop
				download.item.set_file_path (a_title, output_dir)
			end
		end

feature -- Basic operations

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
			output_path := selected_output_path
			if not output_path.is_empty then
				output_path.add_extension (MP4_extension)
				do_conversion (Cmd_convert_to_mp4, "Converting to")
				lio.put_new_line
			end
		end

	download_streams
		require
			valid_downloads: downloads_selected
		do
			across download_list as download loop
				download.item.execute
			end
		end

	merge_streams
		-- merge audio and video streams using same video container
		require
			valid_downloads: downloads_selected
		do
			if attached selected_download as download then
				output_path := selected_output_path
				if not output_path.is_empty then
					output_path.add_extension (download.file_path.extension)

					do_conversion (Cmd_merge, "Merging audio and video streams to")
					lio.put_new_line
				end
			end
		end

	select_downloads
		require
			has_streams: stream_count > 0
		local
			quit: BOOLEAN
		do
			across Current as table until quit loop
				if attached table.item as list then
					list.set_user_choice (url)
					quit := list.off
				end
			end
		end

feature {NONE} -- Implementation

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

	download_list: EL_ARRAYED_LIST [EL_YOUTUBE_STREAM_DOWNLOAD]
		do
			create Result.make (count)
			across Current as table loop
				if attached table.item.download as download then
					Result.extend (download)
				end
			end
		end

	new_time (time_string: STRING): TIME
		do
			create Result.make_from_string (time_string, once "[0]hh:[0]mi:[0]ss.ff3")
		end

	video_duration_fine_seconds: DOUBLE
		do
			if attached selected_download as download then
				Cmd_video_duration.put_path (Var.video_path, download.file_path)
				Cmd_video_duration.execute
				if attached Cmd_video_duration.lines.first as first then
					Result := new_time (first.substring_between_general ("Duration: ", ", ", 1)).fine_seconds
				end
			end
		end

	selected_output_path: FILE_PATH
		do
			if attached selected_download as download then
				Result := download.file_path.without_extension
				Result.remove_extension
			else
				create Result
			end
		end

feature {NONE} -- Internal attributes

	output_dir: DIR_PATH

	output_path: FILE_PATH

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

	Out_time_field: STRING = "out_time="

	Socket_path: FILE_PATH
		once
			Result := Directory.temporary + "el_toolkit-youtube_dl.sock"
		end

end