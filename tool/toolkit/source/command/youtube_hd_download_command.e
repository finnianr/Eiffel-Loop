note
	description: "[
		Download the highest resolution video possible and merge with m4a soundtrack to create a MP4 file.
		
		See [$source YOUTUBE_HD_DOWNLOAD_APP] for more information.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-22 11:29:12 GMT (Thursday 22nd February 2018)"
	revision: "2"

class
	YOUTUBE_HD_DOWNLOAD_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_USER_INPUT

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_DIRECTORY

	EL_FILE_PROGRESS_TRACKER

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_STRING_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_url: like url)
		do
			url  := a_url
			title := Empty_string
			create output_path
		end

feature -- Basic operations

	execute
		local
			best: like best_format; base_name: ZSTRING
		do
			log.enter ("execute")
			if url.is_empty then
				url := User_input.line ("Drag and drop a url")
				url.trim
				lio.put_new_line
			end
			title := User_input.line ("Enter a title")
			lio.put_new_line

			base_name := title.as_lower
			base_name.replace_character (' ', '-')

			lio.put_labeled_string ("Fetching formats for", url)
			lio.put_new_line
			Cmd_get_youtube_options.put_string (Var_url, url)
			Cmd_get_youtube_options.execute

			best := best_format
			lio.put_labeled_string ("M4A audio", best.audio.description)
			lio.put_new_line
			lio.put_labeled_string ("Best video quality", best.video.description)
			lio.put_new_line
			lio.put_new_line

			output_path.audio := download (base_name, best.audio)
			output_path.video := download (base_name, best.video)

			if best.video.extension ~ MP4_extension then
				merge_to_mp4
			else
				convert_to_mp4
			end
			if mp4_path.exists then
				File_system.remove_file (output_path.audio)
				File_system.remove_file (output_path.video)
			end
			lio.put_new_line
			lio.put_line ("DONE")
			log.exit
		end

feature {NONE} -- Implementation

	best_format: TUPLE [audio, video: YOUTUBE_STREAM_INFO]
		local
			max_resolution: INTEGER; stream: YOUTUBE_STREAM_INFO
		do
			create Result
			Result := [Default_stream_info, Default_stream_info]
			across Cmd_get_youtube_options.lines as line loop
				create stream.make (line.item)
				if stream.code > 0 then
					if stream.is_audio and then stream.extension ~ M4A_extension then
						Result.audio := stream
					elseif stream.is_video then
						if stream.resolution_x > max_resolution
							or else (stream.resolution_x = max_resolution and stream.extension ~ MP4_extension)
						then
							max_resolution := stream.resolution_x
							Result.video := stream
						end
					end
				end
			end
		end

	convert_to_mp4
		do
			mp4_path := output_path.video.with_new_extension (MP4_extension)
			do_conversion (Cmd_convert_to_mp4, "Converting to")
			lio.put_new_line
		end

	download (base_name: ZSTRING; stream: YOUTUBE_STREAM_INFO): EL_FILE_PATH
		do
			Result := Output_dir + base_name
			Result.add_extension (stream.extension)

			lio.put_substitution ("Downloading %S for %S", [stream.type, url])
			lio.put_new_line
			Cmd_download.put_file_path (Var_output_path, Result)
			Cmd_download.put_integer (Var_format, stream.code)
			Cmd_download.put_string (Var_url, url)
			Cmd_download.execute
			lio.put_new_line
		end

	merge_to_mp4
		do
			mp4_path := output_path.video.twin
			output_path.video := mp4_path.with_new_extension (("video." + MP4_extension.to_latin_1))
			File_system.rename_file (mp4_path, output_path.video)

			do_conversion (Cmd_merge, "Merging audio and video streams to")
			lio.put_new_line
		end

	do_conversion (command: EL_OS_COMMAND; description: STRING)
		local
			socket: EL_UNIX_STREAM_SOCKET; progress_display: EL_CONSOLE_FILE_PROGRESS_DISPLAY
			pos_out_time: INTEGER; total_duration: DOUBLE; line: STRING; time: TIME
		do
			total_duration := video_duration_fine_seconds
			lio.put_labeled_string (description, mp4_path.to_string)
			lio.put_new_line

			command.put_path (Var_audio_path, output_path.audio)
			command.put_path (Var_video_path, output_path.video)
			command.put_path (Var_output_path, mp4_path)
			command.put_path (Var_socket_path, Socket_path)
			command.put_string (Var_title, title)

			create socket.make_server (Socket_path)
			socket.listen (1)
			socket.set_blocking

			command.set_forking_mode (True)
			command.execute

			socket.accept
			-- Track progress via Unix socket
			if attached {EL_UNIX_STREAM_SOCKET} socket.accepted as ffmpeg_socket then
				create progress_display.make
				from until ffmpeg_socket.was_error loop
					ffmpeg_socket.read_line
					if ffmpeg_socket.was_error then
						line := ffmpeg_socket.last_string
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
			Cmd_video_duration.put_path (Var_video_path, output_path.video)
			Cmd_video_duration.execute
			Result := new_time (Cmd_video_duration.lines.first.substring_between_general ("Duration: ", ", ", 1)).fine_seconds
		end

feature {NONE} -- Internal attributes

	output_path: TUPLE [audio, video: EL_FILE_PATH]

	mp4_path: EL_FILE_PATH

	title: ZSTRING

	url: ZSTRING

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

	Cmd_download: EL_OS_COMMAND
		once
			create Result.make_with_name ("youtube_download", "youtube-dl -f $format -o $output_path $url")
		end

	Cmd_get_youtube_options: EL_CAPTURED_OS_COMMAND
		once
			create Result.make_with_name ("get_youtube_options", "youtube-dl -F $url")
		end

feature {NONE} -- Variable names

	Var_audio_path: ZSTRING
		once
			Result := "audio_path"
		end

	Var_format: ZSTRING
		once
			Result := "format"
		end

	Var_output_path: ZSTRING
		once
			Result := "output_path"
		end

	Var_socket_path: ZSTRING
		once
			Result := "socket_path"
		end

	Var_title: ZSTRING
		once
			Result := "title"
		end

	Var_url: ZSTRING
		once
			Result := "url"
		end

	Var_video_path: ZSTRING
		once
			Result := "video_path"
		end

feature {NONE} -- Constants

	Default_stream_info: YOUTUBE_STREAM_INFO
		once
			create Result.make_default
		end

	M4A_extension: ZSTRING
		once
			Result := "m4a"
		end

	MP4_extension: ZSTRING
		once
			Result := "mp4"
		end

	Out_time_field: STRING = "out_time="

	Output_dir: EL_DIR_PATH
		once
			Result := "$HOME/Videos"
			Result.expand
		end

	Socket_path: EL_FILE_PATH
		once
			Result := Directory.temporary + "el_toolkit-youtube_dl.sock"
		end

end

