note
	description: "Windows implementation of a special 0 byte created file used as a mutex"
	testing: "${FILE_LOCKING_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-16 9:24:56 GMT (Friday 16th August 2024)"
	revision: "9"

class
	EL_NAMED_FILE_LOCK

inherit
	EL_NAMED_FILE_LOCK_I
		rename
			file_handle as mutex_handle
		redefine
			is_lockable, try_lock, unlock
		end

create
	make

feature {NONE} -- Initialization

	make (a_path: EL_FILE_PATH)
		do
			path := a_path
			make_write (default_pointer)
		ensure then
			is_lockable: is_lockable
		end

feature -- Status query

	is_lockable: BOOLEAN
		do
			Result := True
		end

feature -- Status change

	try_lock
		do
			mutex_handle := c_create_file_mutex (native_path.item)
			is_locked := mutex_handle /= c_invalid_handle_value
			if not is_locked then
				mutex_handle := default_pointer
			end
		end

	unlock
		do
			if is_locked then
				close
				is_locked := False
				File_system.remove_file (path)
			end
		ensure then
			file_removed: old is_locked implies not path.exists
		end

	close
		do
			if is_attached (mutex_handle) and then c_close_handle (mutex_handle) then
				mutex_handle := default_pointer
			end
		end

end