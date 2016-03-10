note
	description: "Summary description for {EL_WAV_TO_MP3_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-04 18:07:36 GMT (Friday 4th March 2016)"
	revision: "5"

class
	EL_WAV_TO_MP3_IMPL

inherit
	EL_COMMAND_IMPL

create
	make

feature -- Access

	Template: STRING
		once
			Result := "[
				lame --id3v2-only --tt "Title" --silent -h -b $bit_rate -m $mode $input_file_path $output_file_path
			]"
		end

end
