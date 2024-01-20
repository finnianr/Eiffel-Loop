note
	description: "Implementation of ${EL_WAV_FADER_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "7"

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