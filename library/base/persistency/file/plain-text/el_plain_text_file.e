note
	description: "[
		Plain text file encoded as UTF-8 by default
		By default it does not write a byte-order mark unless `is_bom_enabled' is set to `True'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-06 8:01:56 GMT (Wednesday 6th May 2020)"
	revision: "5"

class
	EL_PLAIN_TEXT_FILE

inherit
	PLAIN_TEXT_FILE
		rename
			put_string as put_raw_string_8,
			put_character as put_raw_character_8
		redefine
			make_with_name, make_with_path
		end

	EL_OUTPUT_MEDIUM

create
	make, make_with_name, make_with_path, make_closed,
	make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

feature {NONE} -- Initialization

	make_closed
		do
			make_with_name ("closed.txt")
		end

	make_with_name (fn: READABLE_STRING_GENERAL)
			-- Create file object with `fn' as file name.
		do
			Precursor (fn)
			make_default
		end

	make_with_path (a_path: PATH)
		do
			Precursor (a_path)
			make_default
		end

end
