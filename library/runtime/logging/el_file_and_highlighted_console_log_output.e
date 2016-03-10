note
	description: "Summary description for {EL_FILE_AND_HIGHLIGHTED_CONSOLE_LOG_OUTPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
