note
	description: "Implementation of [$source EL_WAV_FADER_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 9:30:54 GMT (Wednesday 1st September 2021)"
	revision: "5"

class
	EL_WAV_FADER_IMP

inherit
	EL_WAV_FADER_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP

create
	make

feature -- Access

	Template: STRING = "sox -V1 $input_file_path $output_file_path fade t $fade_in $duration $fade_out"

end