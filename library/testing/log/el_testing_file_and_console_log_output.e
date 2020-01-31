note
	description: "Extends [$source EL_FILE_AND_CONSOLE_LOG_OUTPUT] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 11:04:21 GMT (Friday 31st January 2020)"
	revision: "4"

class
	EL_TESTING_FILE_AND_CONSOLE_LOG_OUTPUT

inherit
	EL_FILE_AND_CONSOLE_LOG_OUTPUT
		export
			{ANY} extendible
		redefine
			put_file_string
		end

	EL_SHARED_TEST_CRC

create
	make

feature -- Output

	put_file_string (str: STRING)
		do
			Precursor (str); Test_crc.add_string_8 (str)
		end

end
