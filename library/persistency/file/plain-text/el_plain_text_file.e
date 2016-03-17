note
	description: "[
		plain text file encoded as UTF-8 by default
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-17 18:53:51 GMT (Thursday 17th December 2015)"
	revision: "5"

class
	EL_PLAIN_TEXT_FILE

inherit
	EL_FILE
		rename
			index as position,
			put_string as put_encoded_string_8
		undefine
			is_plain_text
		redefine
			make_with_name, make_with_path
		end

	PLAIN_TEXT_FILE
		rename
			copy_to as copy_to_file,
			put_string as put_encoded_string_8
		redefine
			make_with_name, make_with_path
		end

	EL_OUTPUT_MEDIUM

create
	make, make_with_name, make_with_path,
	make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append


feature {NONE} -- Initialization

	make_with_name (fn: READABLE_STRING_GENERAL)
			-- Create file object with `fn' as file name.
		do
			Precursor (fn)
			set_utf_encoding (8)
		end

	make_with_path (a_path: PATH)
		do
			Precursor (a_path)
			set_utf_encoding (8)
		end

feature {NONE} -- Factory

	new_file (file_path: EL_FILE_PATH): like Current
		do
			create Result.make_with_name (file_path)
		end
end
