note
	description: "Unix implementation of EL_APPLICATION_MUTEX_I interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-11 13:31:46 GMT (Wednesday 11th October 2023)"
	revision: "6"

class
	EL_APPLICATION_MUTEX_IMP

inherit
	EL_APPLICATION_MUTEX_I

	EL_MODULE_FILE_SYSTEM

	EL_OS_IMPLEMENTATION

create
	make, make_for_application_mode

feature {NONE} -- Initialization	

	make_default
		do
			create locked_file_path
		end

feature -- Status change

	try_lock (name: ZSTRING)
		do
			locked_file_path := "/tmp/" + name
			locked_file_path.add_extension ("lock")

			create internal_mutex.make (locked_file_path)
			if attached internal_mutex as mutex then
				mutex.try_lock
				is_locked := mutex.is_locked
			end
		end

	unlock
		do
			if attached internal_mutex as mutex then
				mutex.unlock
				is_locked := mutex.is_locked
				if not is_locked then
					mutex.close
					internal_mutex := Void
					File_system.remove_file (locked_file_path)
				end
			end
		end

feature {NONE} -- Internal attributes

	internal_mutex: detachable EL_FILE_MUTEX

	locked_file_path: FILE_PATH

end