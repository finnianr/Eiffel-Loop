note
	description: "File that can be locked for exclusive writing operation"
	testing: "${FILE_LOCKING_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 17:17:46 GMT (Monday 26th August 2024)"
	revision: "6"

class
	EL_LOCKABLE_TEXT_FILE

inherit
	EL_NAMED_FILE_LOCK
		rename
			make as make_open_write
		undefine
			is_fixed_size, is_writeable, remove_file
		end

	EL_LOCKABLE_TEXT_FILE_I

	EL_UNIX_IMPLEMENTATION

create
	make_open_write

feature -- Basic operations

	put_string (str: STRING)
		local
			c_str: ANY; error: INTEGER
		do
			c_str := str.to_c
			last_put_count := c_write (descriptor, $c_str, str.count, $error)
			last_write_ok := last_put_count >= 0
			if not last_write_ok then
				last_put_count := 0
			end
			last_error := error
		end

	wipe_out
		-- wipe out existing file data
		do
			if c_file_truncate (descriptor, 0) /= 0 then
				check
					not_truncated: False
				end
			end
		end

end