note
	description: "Summary description for {EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-11 14:35:48 GMT (Wednesday 11th May 2016)"
	revision: "5"

class
	EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMPL

inherit
	EL_VIDEO_CONVERSION_COMMAND_IMPL

feature -- Access

	-- Note: duration has extra 0.1 secs added to prevent rounding error below the required duration

	Command_arguments: STRING = "-i $input_file_path -loglevel ${log_level} -ss $offset -t ${duration}.1 $output_file_path"
end