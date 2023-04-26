note
	description: "Youtube variable names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-26 17:16:52 GMT (Wednesday 26th April 2023)"
	revision: "9"

deferred class
	EL_YOUTUBE_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

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

	Audio_type: STRING = "audio"

	Video_type: STRING = "video"

	MP4_extension: STRING = "mp4"

feature {NONE} -- Variable names

	Var: TUPLE [audio_path, format, output_path, socket_path, title, url, video_path: STRING]
		once
			create Result
			Tuple.fill (Result, "audio_path, format, output_path, socket_path, title, url, video_path")
		end

end