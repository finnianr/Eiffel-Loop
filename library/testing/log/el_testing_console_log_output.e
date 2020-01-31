note
	description: "Extends [$source EL_CONSOLE_LOG_OUTPUT] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 11:00:24 GMT (Friday 31st January 2020)"
	revision: "5"

class
	EL_TESTING_CONSOLE_LOG_OUTPUT

inherit
	EL_CONSOLE_LOG_OUTPUT
		redefine
			write_console
		end

	EL_SHARED_TEST_CRC

create
	make

feature {NONE} -- Implementation

	write_console (str: READABLE_STRING_GENERAL)
		local
			l_encoded: STRING
		do
			l_encoded := console_encoded (str)
			std_output.put_string (l_encoded)
			Test_crc.add_string_8 (l_encoded)
		end

end
