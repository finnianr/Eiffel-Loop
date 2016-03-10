note
	description: "Summary description for {EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

inherit
	EL_CONSOLE_LOG_OUTPUT
		redefine
			write_string_8
		end

create
	make

feature {NONE} -- Implementation

	write_string_8 (str8: STRING)
		do
			io.put_string (str8)
		end

end
