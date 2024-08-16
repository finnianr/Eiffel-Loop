note
	description: "File that can be locked for exclusive writing operation"
	testing: "${FILE_LOCKING_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-16 9:24:51 GMT (Friday 16th August 2024)"
	revision: "8"

class
	EL_LOCKABLE_TEXT_FILE

inherit
	EL_FILE_LOCK
		redefine
			dispose
		end

create
	make_open_write

feature {NONE} -- Initialization

	make_open_write (a_path: EL_FILE_PATH)
		do
			path := a_path
			if attached Native_string.new_data (a_path) as native_path then
				make_write (c_create_file_write (native_path.item))
			end
		ensure
			is_lockable: is_lockable
		end

feature -- Access

	path: EL_FILE_PATH

feature -- Status report

	last_write_ok: BOOLEAN
			-- Was last write operation successful?

	last_put_count: INTEGER
			-- Last amount of bytes written to pipe

feature -- Basic operations

	put_string (str: STRING)
		-- Write `str' to `file_handle' putting number of written bytes in `last_put_count'.
		require
			locked: is_locked
		local
			c_str: C_STRING; l_bytes: INTEGER; NULL: POINTER
		do
			create c_str.make (str)
			last_write_ok := c_write_file (file_handle, c_str.item, c_str.count, $l_bytes, NULL)
			last_put_count := l_bytes
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

feature -- Status change

	close
		do
			if file_handle /= c_invalid_handle_value and then c_close_handle (file_handle) then
				file_handle := default_pointer
			end
		ensure
			not_lockable: not is_lockable
		end

feature {NONE} -- Implementation

	dispose
		do
			if is_attached (file_handle) and then c_close_handle (file_handle) then
				do_nothing
			end
			Precursor
		end

	is_fixed_size: BOOLEAN
		do
			Result := False
		end

end