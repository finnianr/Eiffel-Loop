note
	description: "Implementation of `EL_WAV_FADER_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 8:37:17 GMT (Thursday 23rd June 2016)"
	revision: "5"

class
	EL_WAV_FADER_IMP

inherit
	EL_WAV_FADER_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			make_default
		end

create
	make

feature -- Access

	Template: STRING = "sox -V1 $input_file_path $output_file_path fade t $fade_in $duration $fade_out"

end