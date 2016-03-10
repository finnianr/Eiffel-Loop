note
	description: "Summary description for {EL_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-26 13:25:08 GMT (Friday 26th June 2015)"
	revision: "3"

deferred class
	EL_FILE

inherit
	FILE
		rename
			copy_to as copy_to_file
		end

	EL_MODULE_FILE_SYSTEM

feature -- Access

	data: MANAGED_POINTER
		require
			closed: is_closed
		do
			if is_closed and then exists then
				open_read
				create Result.make (count)
				read_to_managed_pointer (Result, 0, count)
				close
			else
				create Result.make (0)
			end
		end

feature -- Basic operations

	copy_to (destination_path: EL_FILE_PATH)
		require
			exists_and_closed: is_closed and exists
		local
			file: like Current
		do
			File_system.make_directory (destination_path.parent)
			file := new_file (destination_path)
			file.open_write
			file.put_managed_pointer (data, 0, count)
			file.close
		end

feature {NONE} -- Factory

	new_file (file_path: EL_FILE_PATH): like Current
		deferred
		end
end
