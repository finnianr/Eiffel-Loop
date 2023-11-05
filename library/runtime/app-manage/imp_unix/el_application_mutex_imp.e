note
	description: "Unix implementation of EL_APPLICATION_MUTEX_I interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 14:55:33 GMT (Sunday 5th November 2023)"
	revision: "8"

class
	EL_APPLICATION_MUTEX_IMP

inherit
	EL_APPLICATION_MUTEX_I

	EL_MODULE_FILE_SYSTEM

	EL_UNIX_IMPLEMENTATION

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
		-- you don't need to be root to write this path
			locked_file_path := Run_lock_path #$ [name]
			create file_mutex.make (locked_file_path)
			if attached file_mutex as mutex then
				mutex.try_lock
				is_locked := mutex.is_locked
			end
		end

	unlock
		do
			if attached file_mutex as mutex then
				mutex.unlock
				is_locked := mutex.is_locked
				if not is_locked then
					mutex.close
					file_mutex := Void
					File_system.remove_file (locked_file_path)
				end
			end
		end

feature {NONE} -- Internal attributes

	file_mutex: detachable EL_NAMED_FILE_LOCK

	locked_file_path: FILE_PATH

feature {NONE} -- Constants

	Run_lock_path: ZSTRING
		once
			Result := "/run/lock/%S.lock"
		end

end