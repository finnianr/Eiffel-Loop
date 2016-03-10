note
	description: "Summary description for {EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-25 23:12:27 GMT (Saturday 25th January 2014)"
	revision: "3"

class
	EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

inherit
	EL_FILE_AND_CONSOLE_LOG_OUTPUT
		redefine
			write_string_8
		end

create
	make

feature {NONE} -- Implementation

	write_string_8 (str8: STRING)
		do
			if not Escape_sequences.has (str8) then
				put_file_string (str8)
			end
			if is_directed_to_console.item then
				io.put_string (str8)
			end
		end
end
