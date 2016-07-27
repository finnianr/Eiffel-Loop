note
	description: "Extends `EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT' for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 13:31:50 GMT (Friday 8th July 2016)"
	revision: "4"

class
	EL_TESTING_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

inherit
	EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT
		rename
			make as make_output
		undefine
			write_string
		redefine
			write_string_8
		end

	EL_TESTING_CONSOLE_LOG_OUTPUT
		redefine
			write_string_8
		end

create
	make

feature {NONE} -- Implementation

	write_string_8 (str: STRING)
		do
			io.put_string (str)
			crc_32.add_string_8 (str)
		end
end