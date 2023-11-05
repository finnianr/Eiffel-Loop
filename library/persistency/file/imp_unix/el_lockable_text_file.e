note
	description: "File that can be locked for exclusive writing operation"
	notes: "[
		Tested with [$source MUTEX_FILE_TEST_SET] but revealed a problem that the file count
		is not changing when you overwrite with new content. So something not working.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 14:55:32 GMT (Sunday 5th November 2023)"
	revision: "3"

class
	EL_LOCKABLE_TEXT_FILE

inherit
	EL_NAMED_FILE_LOCK
		rename
			make as make_open_write
		redefine
			is_fixed_size
		end

	EL_UNIX_IMPLEMENTATION

create
	make_open_write

feature -- Basic operations

	put_string (str: STRING)
		require
			locked: is_locked
		local
			c_str: ANY
		do
			c_str := str.to_c
			last_put_count := c_write (descriptor, $c_str, str.count)
		ensure
			last_write_ok: last_write_ok
		end

	wipe_out
		-- wipe out existing file data
		require
			locked: is_locked
		do
			if c_file_truncate (descriptor, 0) /= 0 then
				check
					not_truncated: False
				end
			end
		end

feature -- Measurement

	last_put_count: INTEGER

feature -- Status query

	last_write_ok: BOOLEAN
		do
			Result := last_put_count >= 0
		end

feature {NONE} -- Implementation

	is_fixed_size: BOOLEAN
		do
			Result := False
		end

end