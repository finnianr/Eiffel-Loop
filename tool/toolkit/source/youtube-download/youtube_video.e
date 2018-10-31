note
	description: "Youtube video"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-31 12:31:22 GMT (Wednesday 31st October 2018)"
	revision: "4"

class
	YOUTUBE_VIDEO

inherit
	EL_ZSTRING_CONSTANTS

	YOUTUBE_VARIABLE_NAMES

	EL_MODULE_DIRECTORY

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	make (a_url: ZSTRING)
		local
			stream: YOUTUBE_STREAM
		do
			create selected
			if a_url.is_empty then
				url := User_input.line ("Drag and drop a url")
				url.trim
				lio.put_new_line
			else
				url := a_url
			end
			title := User_input.line ("Enter a title")
			lio.put_new_line

			create output_path
			create stream_table.make (17)
			lio.put_labeled_string ("Fetching formats for", url)
			lio.put_new_line
			Cmd_get_youtube_options.put_string (Var_url, url)
			Cmd_get_youtube_options.execute

			across Cmd_get_youtube_options.lines as line loop
				create stream.make (Current, line.item)
				-- Filter out low resolution videos
				if stream.is_audio or else (stream.is_video and then stream.resolution_x >= Minimum_x_resolution) then
					stream_table [stream.code] := stream
				end
			end
		end

feature -- Access

	selected_audio_stream: YOUTUBE_STREAM
		do
			Result := stream_info (selected.audio_code)
		end

	selected_video_stream: YOUTUBE_STREAM
		do
			Result := stream_info (selected.video_code)
		end

	stream_info (code: NATURAL): YOUTUBE_STREAM
		do
			if stream_table.has_key (code) then
				Result := stream_table.found_item
			else
				create Result.make_default
			end
		end

	title: ZSTRING

	url: ZSTRING

feature -- Basic operations

	cleanup
		do
			if output_path.exists then
				selected_audio_stream.remove
				selected_video_stream.remove
			end
		end

	convert_streams_to_mp4
		require
			audio_and_video_selected: audio_and_video_selected
		do
			output_path := video_output_path
			output_path.add_extension (MP4_extension)
			do_conversion (Cmd_convert_to_mp4, "Converting to")
			lio.put_new_line
		end

	download_streams
		require
			audio_and_video_selected: audio_and_video_selected
		do
			selected_audio_stream.download
			selected_video_stream.download
		end

	merge_streams
		-- merge audio and video streams using same video container
		require
			audio_and_video_selected: audio_and_video_selected
		local
			extension: ZSTRING
		do
			extension := selected_video_stream.download_path.extension
			output_path := video_output_path
			output_path.add_extension (extension)

			do_conversion (Cmd_merge, "Merging audio and video streams to")
			lio.put_new_line
		end

	select_streams
		do
			selected.audio_code := select_stream ("AUDIO", agent {YOUTUBE_STREAM}.is_audio)
			selected.video_code := select_stream ("VIDEO", agent {YOUTUBE_STREAM}.is_video)
		ensure
			audio_and_video_selected: audio_and_video_selected
		end

feature -- Status query

	audio_and_video_selected: BOOLEAN
		do
			Result := stream_table.has (selected.audio_code) and stream_table.has (selected.video_code)
		end

	is_downloaded: BOOLEAN
		do
			Result := selected_audio_stream.download_path.exists and selected_video_stream.download_path.exists
		end

	is_merge_complete: BOOLEAN
		-- `True' if `output_path.exists'
		do
			Result := output_path.exists
		end

feature {NONE} -- Implementation

	display (a_title: ZSTRING; included: PREDICATE [YOUTUBE_STREAM])
		do
			lio.put_line (a_title)
			across stream_table as stream loop
				if included (stream.item) then
					lio.put_line (stream.item.description)
				end
			end
			lio.put_new_line
		end

	do_conversion (command: EL_OS_COMMAND; description: STRING)
		local
			socket: EL_UNIX_STREAM_SOCKET; progress_display: EL_CONSOLE_FILE_PROGRESS_DISPLAY
			pos_out_time: INTEGER; total_duration: DOUBLE; line: STRING; time: TIME
		do
			total_duration := video_duration_fine_seconds
			lio.put_labeled_string (description, output_path.to_string)
			lio.put_new_line

			command.put_path (Var_audio_path, selected_audio_stream.download_path)
			command.put_path (Var_video_path, selected_video_stream.download_path)
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

	select_stream (type: STRING; included: PREDICATE [YOUTUBE_STREAM]): NATURAL
		local
			l_title, prompt_template: ZSTRING
		do
			l_title := type; l_title.append_string_general (" STREAMS")
			prompt_template := "Enter %S code"
			from until stream_table.has_key (Result) and then included (stream_table.found_item) loop
				display (l_title, included)
				Result := User_input.natural (prompt_template #$ [type.as_lower])
				lio.put_new_line
			end
		end

	video_duration_fine_seconds: DOUBLE
		do
			Cmd_video_duration.put_path (Var_video_path, selected_video_stream.download_path)
			Cmd_video_duration.execute
			Result := new_time (Cmd_video_duration.lines.first.substring_between_general ("Duration: ", ", ", 1)).fine_seconds
		end

	video_output_path: EL_FILE_PATH
		do
			Result := selected_video_stream.download_path.without_extension
			Result.remove_extension
		end

feature {NONE} -- Internal attributes

	output_path: EL_FILE_PATH

	selected: TUPLE [audio_code, video_code: NATURAL]

	stream_table: HASH_TABLE [YOUTUBE_STREAM, NATURAL]

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

	Minimum_x_resolution: INTEGER = 1920

	Out_time_field: STRING = "out_time="

	Socket_path: EL_FILE_PATH
		once
			Result := Directory.temporary + "el_toolkit-youtube_dl.sock"
		end

end
