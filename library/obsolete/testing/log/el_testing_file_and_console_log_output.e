note
	description: "Extends [$source EL_FILE_AND_CONSOLE_LOG_OUTPUT] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-18 12:25:31 GMT (Tuesday 18th January 2022)"
	revision: "5"

class
	EL_TESTING_FILE_AND_CONSOLE_LOG_OUTPUT

obsolete
	"Use EL_CRC_32_FILE_AND_CONSOLE_LOG_OUTPUT"

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