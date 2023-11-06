note
	description: "Windows file lock information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-06 8:44:37 GMT (Monday 6th November 2023)"
	revision: "4"

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

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make, make_write

feature {NONE} -- Initialization

	make (length: INTEGER)
		do
			make_default
			c_set_flock_whence (self_ptr, Seek_set)
			c_set_flock_start (self_ptr, 0)
			set_length (length)
		end

	make_write (a_descriptor: INTEGER)
		do
			descriptor := a_descriptor
			make (0) -- 0 means any length of file
			set_write_lock
		end

feature -- Status query

	is_locked: BOOLEAN

	is_lockable: BOOLEAN
		do
			Result := descriptor.to_boolean
		end

feature -- Status change

	try_lock
		require
			is_lockable: is_lockable
		do
			is_locked := c_aquire_lock (descriptor, self_ptr) /= -1
		end

	try_until_locked (interval_ms: INTEGER)
		-- try to lock repeatedly until `is_locked' with `interval_ms' millisecs wait between attempts
		do
			from until is_locked loop
				try_lock
				if not is_locked then
					Execution_environment.sleep (interval_ms)
				end
			end
		end

	unlock
		require
			locked: is_locked
			is_lockable: is_lockable
		do
			set_unlocked
			is_locked := c_aquire_lock (descriptor, self_ptr) = -1
		ensure
			unlocked: not is_locked
		end

feature {NONE} -- Implementation

	set_length (length: INTEGER)
		do
			c_set_flock_length (self_ptr, length)
		end

	set_unlocked
		do
			c_set_flock_type (self_ptr, File_unlock)
		end

	set_write_lock
		do
			c_set_flock_type (self_ptr, File_write_lock)
		end

feature {NONE} -- Internal attributes

	descriptor: INTEGER

feature {NONE} -- Constants

	File_write_lock: INTEGER
		once
			Result := c_file_write_lock
		end

	File_unlock: INTEGER
		once
			Result := c_file_unlock
		end

	Seek_set: INTEGER
		once
			Result := c_seek_set
		end

end