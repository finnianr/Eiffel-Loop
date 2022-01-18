note
	description: "Extends [$source EL_CONSOLE_LOG_OUTPUT] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-18 12:26:47 GMT (Tuesday 18th January 2022)"
	revision: "7"

class
	EL_TESTING_CONSOLE_LOG_OUTPUT

obsolete
	"Use EL_CRC_32_CONSOLE_LOG_OUTPUT"

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