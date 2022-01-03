note
	description: "Video command factory  accessible via [$source EL_MODULE_AUDIO_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "2"

class
	EL_VIDEO_COMMAND_FACTORY

feature -- Factory

	new_video_to_mp3 (input_file_path, output_file_path: FILE_PATH): EL_VIDEO_TO_MP3_COMMAND_I
		do
			create {EL_VIDEO_TO_MP3_COMMAND_IMP} Result.make (input_file_path, output_file_path)
		end

end
