note
	description: "Extends [$source EL_CONSOLE_LOG_OUTPUT] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-26 9:43:08 GMT (Tuesday 26th October 2021)"
	revision: "6"

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
			l_encoded := Console.encoded (str)
			std_output.put_string (l_encoded)
			Test_crc.add_string_8 (l_encoded)
		end

end