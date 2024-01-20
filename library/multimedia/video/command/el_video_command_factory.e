note
	description: "Video command factory  accessible via ${EL_MODULE_AUDIO_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	EL_VIDEO_COMMAND_FACTORY

feature -- Factory

	new_video_to_mp3 (input_file_path, output_file_path: FILE_PATH): EL_VIDEO_TO_MP3_COMMAND_I
		do
			create {EL_VIDEO_TO_MP3_COMMAND_IMP} Result.make (input_file_path, output_file_path)
		end

end