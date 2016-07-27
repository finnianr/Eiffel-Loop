note
	description: "Summary description for {EL_WAV_FADER_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-16 17:16:08 GMT (Monday 16th May 2016)"
	revision: "5"

class
	EL_WAV_FADER_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature -- Access

	Template: STRING = "sox -V1 $input_file_path $output_file_path fade t $fade_in $duration $fade_out"

end