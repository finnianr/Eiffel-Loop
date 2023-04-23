note
	description: "Youtube video"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-23 18:59:37 GMT (Sunday 23rd April 2023)"
	revision: "16"

class
	EL_YOUTUBE_VIDEO

inherit
	ANY

	EL_ZSTRING_CONSTANTS

	EL_YOUTUBE_CONSTANTS

	EL_MODULE_DIRECTORY

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

create
	make, make_default

feature {NONE} -- Initialization

	make (a_url, a_title: ZSTRING)
		require
			not_empty: not a_url.is_empty
		do
			make_default
			url := a_url; title := a_title

			lio.put_labeled_string ("Fetching formats for", a_url)
			lio.put_new_line_x2
			Cmd_get_youtube_options.put_string (Var.url, a_url)
			Cmd_get_youtube_options.execute

			across stream_list_table as table loop
				table.item.fill (Cmd_get_youtube_options.lines, table.key, 8)
			end
		end

	make_default
		do
			create url.make_empty
			create title.make_empty
			create output_path
			create stream_list_table.make (<<
				[Audio_only, create {EL_YOUTUBE_STREAM_LIST}.make (11)],
				[Video_only, create {EL_YOUTUBE_STREAM_LIST}.make (11)]
			>>)
			create download_table
		end

feature -- Access

	title: ZSTRING

	url: ZSTRING

	download: EL_YOUTUBE_STREAM_DOWNLOAD
		-- video stream download
		do
			if download_table.has_key (Video_only) then
				Result := download_table.found_item
			else
				Result := Default_download
			end
		end

feature -- Measurement

	stream_count: INTEGER
		do
			across stream_list_table as table loop
				Result := Result + table.item.count
			end
		end

feature -- Basic operations

	cleanup
		do
			if output_path.exists then
				across download_table as table loop
					table.item.remove
				end
			end
		end

	convert_streams_to_mp4
		require
			valid_downloads: valid_downloads
		do
			output_path := video_output_path
			output_path.add_extension (MP4_extension)
			do_conversion (Cmd_convert_to_mp4, "Converting to")
			lio.put_new_line
		end

	download_streams
		require
			valid_downloads: valid_downloads
		do
			across download_table as table loop
				table.item.execute
			end
		end

	merge_streams
		-- merge audio and video streams using same video container
		require
			valid_downloads: valid_downloads
		local
			extension: ZSTRING
		do
			extension := download.file_path.extension
			output_path := video_output_path
			output_path.add_extension (extension)

			do_conversion (Cmd_merge, "Merging audio and video streams to")
			lio.put_new_line
		end

	select_downloads
		require
			has_streams: stream_count > 0
		local
			selector: EL_YOUTUBE_STREAM_SELECTOR
		do
			across stream_list_table as table loop
				create selector.make (stream_name (table.key), table.item)
				selector.get_stream_index
				download_table [table.key] := selector.download (title, url, output_dir)
			end
		ensure
			valid_downloads: valid_downloads
		end

feature -- Status query

	downloads_exists: BOOLEAN
		do
			if download_table.count = 2 then
				Result := across download_table as table all table.item.exists end
			end
		end

	is_merge_complete: BOOLEAN
		-- `True' if `output_path.exists'
		do
			Result := output_path.exists
		end

	valid_downloads: BOOLEAN
		do
			Result := download_table.has (Audio_only) and download_table.has (Video_only)
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

			if download_table.has_key (Audio_only) then
				command.put_path (Var.audio_path, download_table.found_item.file_path)
			end
			if download_table.has_key (Video_only) then
				command.put_path (Var.video_path, download_table.found_item.file_path)
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

	new_time (time_string: STRING): TIME
		do
			create Result.make_from_string (time_string, once "[0]hh:[0]mi:[0]ss.ff3")
		end

	stream_name (selector: STRING): STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.substring_to (selector, ' ', default_pointer)
			Result.to_upper
		end

	video_duration_fine_seconds: DOUBLE
		do
			Cmd_video_duration.put_path (Var.video_path, download.file_path)
			Cmd_video_duration.execute
			Result := new_time (
				Cmd_video_duration.lines.first.substring_between_general ("Duration: ", ", ", 1)
			).fine_seconds
		end

	video_output_path: FILE_PATH
		do
			Result := download.file_path.without_extension
			Result.remove_extension
		end

feature {NONE} -- Internal attributes

	output_path: FILE_PATH

	stream_list_table: EL_HASH_TABLE [EL_YOUTUBE_STREAM_LIST, STRING]

	download_table: EL_HASH_TABLE [EL_YOUTUBE_STREAM_DOWNLOAD, STRING]

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

	Default_download: EL_YOUTUBE_STREAM_DOWNLOAD
		once
			create Result.make_default
		end

	Minimum_x_resolution: INTEGER = 1920

	Out_time_field: STRING = "out_time="

	Output_dir: DIR_PATH
		once
			Result := "$HOME/Videos"
			Result.expand
		end

	Socket_path: FILE_PATH
		once
			Result := Directory.temporary + "el_toolkit-youtube_dl.sock"
		end

end