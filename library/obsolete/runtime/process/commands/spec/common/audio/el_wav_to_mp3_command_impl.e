note
	description: "Summary description for {EL_WAV_TO_MP3_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-18 13:43:00 GMT (Saturday 18th June 2016)"
	revision: "5"

class
	EL_WAV_TO_MP3_COMMAND_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature -- Access

	Template: STRING
		once
			Result := "[
				lame --id3v2-only --tt "Title" --silent -h -b $bit_rate -m $mode $input_file_path $output_file_path
			]"
		end

end
