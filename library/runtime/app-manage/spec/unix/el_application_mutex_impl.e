note
	description: "Summary description for {EL_APPLICATION_MUTEX_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 6:58:53 GMT (Wednesday 16th December 2015)"
	revision: "6"

class
	EL_APPLICATION_MUTEX_IMPL

inherit
	EL_PLATFORM_IMPL
		undefine
			is_equal, copy
		redefine
			make
		end

	EL_FILE_API
		undefine
			is_equal, copy, dispose
		end

	MANAGED_POINTER
		rename
			make as make_file_lock_info,
			item as file_lock_info
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization	

	make
		do
			make_file_lock_info (0)
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
				make_file_lock_info (c_flock_struct_size)

				c_set_flock_type (file_lock_info, File_write_lock)
				c_set_flock_whence (file_lock_info, Seek_set)
				c_set_flock_start (file_lock_info, 0)
				c_set_flock_length (file_lock_info, 1)

				if c_aquire_lock (locked_file_descriptor, file_lock_info) /= -1 then
					is_locked := True
				end
			end
		end

	unlock
		require
			is_locked: is_locked
		local
			status: INTEGER
		do
			c_set_flock_type (file_lock_info, File_unlock)
			status := c_aquire_lock (locked_file_descriptor, file_lock_info)
			is_locked := status = -1
			if not is_locked then
				status := c_close (locked_file_descriptor)
				File_system.remove_file (locked_file_path)
			end
		end

feature -- Status query

	is_locked: BOOLEAN

feature {NONE} -- Implementation

	locked_file_descriptor: INTEGER

	locked_file_path: EL_FILE_PATH

end
