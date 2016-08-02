note
	description: "Unix implementation of EL_APPLICATION_MUTEX_I interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 8:48:40 GMT (Friday 24th June 2016)"
	revision: "1"

class
	EL_APPLICATION_MUTEX_IMP

inherit
	EL_APPLICATION_MUTEX_I

	EL_FILE_API

	EL_MODULE_FILE_SYSTEM

	EL_OS_IMPLEMENTATION

create
	make, make_for_application_mode

feature {NONE} -- Initialization	

	make_default
		do
			create lock_info.make (c_flock_struct_size)
			create locked_file_path
		end

feature -- Status change

	try_lock (name: ZSTRING)
		local
			native_path: NATIVE_STRING
		do
			locked_file_path := "/tmp/" + name
			locked_file_path.add_extension ("lock")
			create native_path.make (locked_file_path.unicode)

			locked_file_descriptor := c_create_write_only (native_path.managed_data.item)
			if locked_file_descriptor /= -1 then
				c_set_flock_type (lock_info.item, File_write_lock)
				c_set_flock_whence (lock_info.item, Seek_set)
				c_set_flock_start (lock_info.item, 0)
				c_set_flock_length (lock_info.item, 1)

				if c_aquire_lock (locked_file_descriptor, lock_info.item) /= -1 then
					is_locked := True
				end
			end
		end

	unlock
		local
			status: INTEGER
		do
			c_set_flock_type (lock_info.item, File_unlock)
			status := c_aquire_lock (locked_file_descriptor, lock_info.item)
			is_locked := status = -1
			if not is_locked then
				status := c_close (locked_file_descriptor)
				File_system.remove_file (locked_file_path)
			end
		end

feature {NONE} -- Implementation

	lock_info: MANAGED_POINTER

	locked_file_descriptor: INTEGER

	locked_file_path: EL_FILE_PATH

end