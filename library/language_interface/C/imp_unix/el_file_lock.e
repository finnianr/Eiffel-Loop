note
	description: "Unix file lock information"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_FILE_LOCK

inherit
	EL_ALLOCATED_C_OBJECT
		rename
			c_size_of as c_flock_struct_size
		end

	EL_FILE_LOCK_C_API
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (length: INTEGER)
		do
			make_default
			c_set_flock_type (self_ptr, File_write_lock)
			c_set_flock_whence (self_ptr, Seek_set)
			c_set_flock_start (self_ptr, 0)

			c_set_flock_length (self_ptr, length)
		end

feature -- Status change

	set_unlocked
		do
			c_set_flock_type (self_ptr, File_unlock)
		end

end
