note
	description: "File that can be locked for exclusive writing operation"
	notes: "[
		STATUS 22 Nov 2023

		Passes test ${FILE_LOCKING_TEST_SET}.test_mutex_file
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-22 12:27:21 GMT (Wednesday 22nd November 2023)"
	revision: "5"

class
	EL_LOCKABLE_TEXT_FILE

inherit
	EL_NAMED_FILE_LOCK
		rename
			make as make_open_write,
			last_written_bytes as last_put_count,
			last_write_successful as last_write_ok
		redefine
			is_fixed_size
		end

create
	make_open_write

feature -- Basic operations

	put_string (str: STRING)
		require
			locked: is_locked
		do
			put_file_string (file_handle, str)
		ensure
			last_write_ok: last_write_ok
		end

	wipe_out
		-- wipe out existing file data
		require
			locked: is_locked
		do
			c_file_truncate (file_handle)
		end

feature {NONE} -- Implementation

	is_fixed_size: BOOLEAN
		do
			Result := False
		end

end