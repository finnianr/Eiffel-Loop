note
	description: "[
		Windows batch script encoded using default code page returned by chcp
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-28 8:49:45 GMT (Sunday 28th June 2020)"
	revision: "5"

class
	EL_BATCH_SCRIPT_FILE

inherit
	EL_PLAIN_TEXT_FILE
		redefine
			put_bom, put_string, put_string_32, put_string_8, put_latin_1
		end

	EL_CONSOLE_ENCODEABLE
		rename
			Utf_8 as Utf_8_encoding
		end

create
	make, make_with_name, make_with_path,
	make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

feature -- Output

	put_bom
		do
			-- Do nothing because putting a BOM in a Windows batch script prevents execution by cmd.exe
		end

	put_string (str: ZSTRING)
		do
			put_string_32 (str)
		end

	put_string_32 (str_32: STRING_32)
		do
			put_console_encoded (str_32)
		end

	put_string_8, put_latin_1 (str: STRING)
		do
			put_console_encoded (str)
		end

feature {NONE} -- Implementation

	put_console_encoded (str: READABLE_STRING_GENERAL)
		do
			put_raw_string_8 (console_encoded (str))
		end

end
