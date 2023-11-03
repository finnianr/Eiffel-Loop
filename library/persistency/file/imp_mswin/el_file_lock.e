note
	description: "Windows file lock information"
	notes: "[
		Not yet implemented on Windows. (Copied source from Unix version as a guide)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-03 18:12:55 GMT (Friday 3rd November 2023)"
	revision: "2"

class
	EL_FILE_LOCK

inherit
	EL_ALLOCATED_C_OBJECT
--		rename
--			c_size_of as c_flock_struct_size
--		end

--	EL_FILE_LOCK_C_API
--		undefine
--			copy, is_equal
--		end

create
	make

feature {NONE} -- Initialization

	make (length: INTEGER)
		do
			make_default

--			c_set_flock_whence (self_ptr, Seek_set)
--			c_set_flock_start (self_ptr, 0)
--			c_set_flock_length (self_ptr, length)
		end

feature -- Status change

	set_unlocked
		do
--			c_set_flock_type (self_ptr, File_unlock)
		end

	set_write_lock
		do
--			c_set_flock_type (self_ptr, File_write_lock)
		end

feature {NONE} -- Implementation

	c_size_of: INTEGER
		-- size of C struct to allocate
		do
		end

end