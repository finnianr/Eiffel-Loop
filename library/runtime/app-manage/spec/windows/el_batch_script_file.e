note
	description: "[
		Windows batch script encoded using default code page returned by chcp
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-04-06 16:28:52 GMT (Wednesday 6th April 2016)"
	revision: "1"

class
	EL_BATCH_SCRIPT_FILE

inherit
	EL_PLAIN_TEXT_FILE
		redefine
			put_bom, put_string_z, put_string_32, put_string_8, put_latin_1
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

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

	put_string_z (str: ZSTRING)
		do
			put_readable_string (str.to_unicode)
		end

	put_string_32 (str_32: STRING_32)
		do
			put_readable_string (str_32)
		end

	put_string_8, put_latin_1 (str: STRING)
		do
			put_readable_string (str)
		end

feature {NONE} -- Implementation

	put_readable_string (str: READABLE_STRING_GENERAL)
		do
			UTF_32_encoding.convert_to (Default_code_page, str)
			if UTF_32_encoding.last_conversion_successful then
				put_encoded_string_8 (Utf_32_encoding.last_converted_string_8)
			end
		end

feature {NONE} -- Constants

	Default_code_page: ENCODING
			-- Default Windows console code page at application start
		once
			create Result.make (Execution_environment.last_code_page.out)
		end

	UTF_32_encoding: ENCODING
		once
			create Result.make ({CODE_PAGE_CONSTANTS}.Utf32)
		end

end