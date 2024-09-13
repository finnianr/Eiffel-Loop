note
	description: "File that can be locked for exclusive writing operation"
	testing: "${FILE_LOCKING_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 16:14:09 GMT (Friday 13th September 2024)"
	revision: "10"

class
	EL_LOCKABLE_TEXT_FILE

inherit
	EL_FILE_LOCK
		redefine
			dispose
		end

	EL_LOCKABLE_TEXT_FILE_I

create
	make_open_write

feature {NONE} -- Initialization

	make_open_write (a_path: EL_FILE_PATH)
		local
			error: NATURAL
		do
			path := a_path
			if attached Native_string.new_data (a_path) as native_path then
				make_write (c_create_file_write (native_path.item, $error))
				last_error := error.to_integer_32
			end
		ensure
			is_lockable: is_lockable
		end

feature -- Access

	path: EL_FILE_PATH

feature -- Basic operations

	put_string (str: STRING)
		-- Write `str' to `file_handle' putting number of written bytes in `last_put_count'.
		local
			c_str: C_STRING; l_bytes: INTEGER; NULL: POINTER
		do
			create c_str.make (str)
			last_write_ok := c_write_file (file_handle, c_str.item, c_str.count, $l_bytes, NULL)
			last_put_count := l_bytes
		end

	wipe_out
		-- wipe out existing file data
		do
			c_file_truncate (file_handle)
		end

feature -- Status change

	close
		do
			if file_handle.to_integer_32 > 0 and then c_close_handle (file_handle) then
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

end