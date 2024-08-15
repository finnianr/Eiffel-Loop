note
	description: "[
		Windows implementation of a special 0 byte created file used as a mutex
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-15 17:45:33 GMT (Thursday 15th August 2024)"
	revision: "8"

class
	EL_NAMED_FILE_LOCK

inherit
	EL_FILE_LOCK
		rename
			make as make_lock,
			file_handle as mutex_handle
		redefine
			dispose, is_lockable, try_lock, unlock
		end

create
	make

feature {NONE} -- Initialization

	make (a_path: EL_FILE_PATH)
		do
			path := a_path
			make_write (default_pointer)
		ensure
			is_lockable: is_lockable
		end

feature -- Access

	path: EL_FILE_PATH

feature -- Status query

	is_lockable: BOOLEAN
		do
			Result := True
		end

feature -- Status change

	try_lock
		do
			if attached Native_string.new_data (path) as native_path then
				mutex_handle := c_create_file_mutex (native_path.item)
			end
			is_locked := mutex_handle /= c_invalid_handle_value
		end

	unlock, close
		local
			closed: BOOLEAN
		do
			if is_locked and then c_close_handle (mutex_handle) then
				mutex_handle := default_pointer
				is_locked := False
			end
		end

feature {NONE} -- Implementation

	is_fixed_size: BOOLEAN
		do
			Result := True
		end

	dispose
		do
			close; Precursor
		end

end