note
	description: "Implementation of [$source EL_WAV_TO_MP3_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:26:32 GMT (Wednesday 21st February 2018)"
	revision: "3"

class
	EL_WAV_TO_MP3_COMMAND_IMP

inherit
	EL_WAV_TO_MP3_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			make_default
		end

create
	make, make_default

feature -- Access

	Template: STRING
		once
			Result := "[
				lame --id3v2-only --id3v2-utf16 --tl "$album" --ta "$artist" --tt "$title" 
					--silent -h -b $bit_rate -m $mode $input_file_path $output_file_path
			]"
		end

end
