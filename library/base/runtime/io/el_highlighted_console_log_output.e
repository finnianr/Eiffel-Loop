note
	description: "Summary description for {EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-12-14 13:16:02 GMT (Wednesday 14th December 2016)"
	revision: "2"

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

	write_string_8 (str: STRING)
		do
			std_output.put_string (str)
		end

end
