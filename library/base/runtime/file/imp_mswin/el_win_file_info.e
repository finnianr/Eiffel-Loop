note
	description: "[
		Get or set file time information using Windows system call `GetFileTime' and `SetFileTime'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 16:11:59 GMT (Friday 13th September 2024)"
	revision: "10"

class
	EL_WIN_FILE_INFO

inherit
	EL_WIN_FILE_INFO_C_API

	EL_WIN_32_C_API

create
	make

feature {NONE} -- Initialization

	make
		do
			create mswin_date_time.make
		end

feature -- File attribute query

	unix_creation_time: INTEGER
		require
			readable: is_open
		do
			Result := mswin_date_time.unix_file_time_creation (handle)
		end

	unix_last_access_time: INTEGER
		require
			readable: is_open
		do
			Result := mswin_date_time.unix_file_time_last_access (handle)
		end

	unix_last_write_time: INTEGER
		require
			readable: is_open
		do
			Result := mswin_date_time.unix_file_time_last_write (handle)
		end

feature -- File attribute change

	set_unix_creation_time (a_unix_date_time: INTEGER)
		require
			writable: is_open_write
		do
			mswin_date_time.set_file_time_creation_from_unix (handle, a_unix_date_time)
		ensure
			is_set: a_unix_date_time = unix_creation_time
		end

	set_unix_last_write_time (a_unix_date_time: INTEGER)
		require
			writable: is_open_write
		do
			mswin_date_time.set_file_time_last_write_from_unix (handle, a_unix_date_time)
		ensure
			is_set: a_unix_date_time = unix_last_write_time
		end

	set_unix_last_access_time (a_unix_date_time: INTEGER)
		require
			writable: is_open_write
		do
			mswin_date_time.set_file_time_last_access_from_unix (handle, a_unix_date_time)
		ensure
			is_set: a_unix_date_time = unix_last_access_time
		end

feature {NATIVE_STRING_HANDLER} -- Status change

	open_read (file_path: MANAGED_POINTER)
		do
			if is_open then
				close
			end
			handle := c_open_file_read (file_path.item)
			if is_open then
				state := State_open_read
			end
		end

	open_write (file_path: MANAGED_POINTER)
		do
			if is_open then
				close
			end
			handle := c_open_file_write (file_path.item)
			if is_open then
				state := State_open_write
			end
		end

feature -- Status query

	is_open: BOOLEAN
		do
			Result := handle.to_integer_32 > 0
		end

	is_open_read: BOOLEAN
		do
			Result := is_open and state = State_open_read
		end

	is_open_write: BOOLEAN
		do
			Result := is_open and state = State_open_write
		end

feature -- Status change

	close
		do
			if is_open and then c_close_handle (handle) then
				handle := default_pointer
				state := State_closed
			end
		ensure
			closed: not is_open
		end

feature {NONE} -- Internal attributes

	handle: POINTER

	call_succeeded: BOOLEAN

	state: INTEGER

feature {NONE} -- Constants

	mswin_date_time: EL_WIN_FILE_DATE_TIME

	State_closed: INTEGER = 0

	State_open_read: INTEGER = 1

	State_open_write: INTEGER = 2

end