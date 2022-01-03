note
	description: "Youtube video"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "12"

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
	make

feature {NONE} -- Initialization

	make (a_url: ZSTRING)
		require
			not_empty: not a_url.is_empty
		do
			url := a_url; title := User_input.line ("Enter a title")
			lio.put_new_line
			create output_path
			create stream_table.make (a_url, 6)
			download := [Default_download, Default_download]
		end

feature -- Access

	download: TUPLE [audio, video: EL_YOUTUBE_STREAM_DOWNLOAD]

	title: ZSTRING

	url: ZSTRING

feature -- Basic operations

	cleanup
		do
			if output_path.exists then
				download.audio.remove
				download.video.remove
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
			download.audio.execute
			download.video.execute
		end

	merge_streams
		-- merge audio and video streams using same video container
		require
			valid_downloads: valid_downloads
		local
			extension: ZSTRING
		do
			extension := download.video.file_path.extension
			output_path := video_output_path
			output_path.add_extension (extension)

			do_conversion (Cmd_merge, "Merging audio and video streams to")
			lio.put_new_line
		end

	select_downloads
		local
			selector: EL_YOUTUBE_STREAM_SELECTOR
		do
			across << Audio_stream, Video_stream >> as stream loop
				create selector.make (stream.item, stream_table)
				selector.get_code
				download.put_reference (selector.download (output_dir, title), stream.cursor_index)
			end
		ensure
			valid_downloads: valid_downloads
		end

feature -- Status query

	valid_downloads: BOOLEAN
		do
			Result := not (download.audio.is_default or download.video.is_default)
		end

	downloads_exists: BOOLEAN
		do
			Result := download.audio.exists and download.video.exists
		end

	is_merge_complete: BOOLEAN
		-- `True' if `output_path.exists'
		do
			Result := output_path.exists
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

			command.put_path (Var_audio_path, download.audio.file_path)
			command.put_path (Var_video_path, download.video.file_path)
			command.put_path (Var_output_path, output_path)
			command.put_path (Var_socket_path, Socket_path)
			command.put_string (Var_title, title)

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

	video_duration_fine_seconds: DOUBLE
		do
			Cmd_video_duration.put_path (Var_video_path, download.video.file_path)
			Cmd_video_duration.execute
			Result := new_time (Cmd_video_duration.lines.first.substring_between_general ("Duration: ", ", ", 1)).fine_seconds
		end

	video_output_path: FILE_PATH
		do
			Result := download.video.file_path.without_extension
			Result.remove_extension
		end

feature {NONE} -- Internal attributes

	output_path: FILE_PATH

	stream_table: EL_YOUTUBE_STREAM_TABLE

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

