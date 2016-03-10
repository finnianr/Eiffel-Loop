note
	description: "Summary description for {EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-09 14:26:41 GMT (Saturday 9th November 2013)"
	revision: "3"

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
