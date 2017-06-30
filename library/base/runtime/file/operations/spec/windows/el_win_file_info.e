note
	description: "[
		Get or set file time information using Windows system call `GetFileTime' and `SetFileTime'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-23 10:28:52 GMT (Friday 23rd June 2017)"
	revision: "4"

class
	EL_WIN_FILE_INFO

inherit
	NATIVE_STRING_HANDLER

	EL_WIN_FILE_INFO_C_API

create
	make

feature {NONE} -- Initialization

	make
		do
			internal_name := Default_internal_name
			handle := default_handle
		end

feature -- Access

	unix_creation_time: INTEGER
		require
			readable: is_open
		do
			Result := unix_date_time (Time_creation)
		end

	unix_last_access_time: INTEGER
		require
			readable: is_open
		do
			Result := unix_date_time (Time_last_access)
		end

	unix_last_write_time: INTEGER
		require
			readable: is_open
		do
			Result := unix_date_time (Time_last_write)
		end

feature -- Element change

	set_unix_creation_time (a_date_time: like unix_date_time)
		require
			writable: is_open_write
		do
			set_unix_date_time (a_date_time, Time_creation)
		ensure
			is_set: a_date_time = unix_creation_time
		end

	set_unix_last_write_time (a_date_time: like unix_date_time)
		require
			writable: is_open_write
		do
			set_unix_date_time (a_date_time, Time_last_write)
		ensure
			is_set: a_date_time = unix_last_write_time
		end

	set_unix_last_access_time (a_date_time: like unix_date_time)
		require
			writable: is_open_write
		do
			set_unix_date_time (a_date_time, Time_last_access)
		ensure
			is_set: a_date_time = unix_last_access_time
		end

feature -- Status change

	open_read (file_path: READABLE_STRING_GENERAL)
		do
			if is_open then
				close
			end
			internal_name := File_info.file_name_to_pointer (file_path, internal_name)
			handle := c_open_file_read (internal_name.item)
			if is_open then
				state := State_open_read
			else
				internal_name := Default_internal_name
			end
		end

	open_write (file_path: READABLE_STRING_GENERAL)
		do
			if is_open then
				close
			end
			internal_name := File_info.file_name_to_pointer (file_path, internal_name)
			handle := c_open_file_write (internal_name.item)
			if is_open then
				state := State_open_write
			else
				internal_name := Default_internal_name
			end
		end

feature -- Status query

	is_open: BOOLEAN
		do
			Result := handle /= default_handle
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
			if is_open and then c_close_file (handle) then
				handle := default_handle
				internal_name := Default_internal_name
				state := State_closed
			end
		ensure
			closed: not is_open
		end

feature {NONE} -- Implementation

	set_unix_date_time (a_date_time, time_code: INTEGER)
		do
			Date_time.set_unix_value (a_date_time)
			inspect time_code
				when Time_creation then
					call_succeeded := c_set_file_time (handle, Date_time.item, Default_pointer, Default_pointer)
				when Time_last_access then
					call_succeeded := c_set_file_time (handle, Default_pointer, Date_time.item, Default_pointer)
				when Time_last_write then
					call_succeeded := c_set_file_time (handle, Default_pointer, Default_pointer, Date_time.item)
			else
				call_succeeded := False
			end
		ensure
			time_set: call_succeeded
		end

	unix_date_time (time_code: INTEGER): INTEGER
		do
			inspect time_code
				when Time_creation then
					call_succeeded := c_get_file_time (handle, Date_time.item, Default_pointer, Default_pointer)
				when Time_last_access then
					call_succeeded := c_get_file_time (handle, Default_pointer, Date_time.item, Default_pointer)
				when Time_last_write then
					call_succeeded := c_get_file_time (handle, Default_pointer, Default_pointer, Date_time.item)
			else
				call_succeeded := False
			end
			if call_succeeded then
				Result := Date_time.unix_value
			end
		ensure
			time_set: call_succeeded
		end

feature {NONE} -- Internal attributes

	internal_name: MANAGED_POINTER

	handle: NATURAL

	call_succeeded: BOOLEAN

	state: INTEGER

feature {NONE} -- Constants

	Date_time: EL_WIN_FILE_DATE_TIME
		once
			create Result.make
		end

	Default_internal_name: MANAGED_POINTER
		once ("PROCESS")
			create internal_name.make (0)
		end

	File_info: FILE_INFO
			-- Information about the file.
		once
			create Result.make
		end

	Time_creation: INTEGER = 1

	Time_last_access: INTEGER = 2

	Time_last_write: INTEGER = 3

	State_closed: INTEGER = 0

	State_open_read: INTEGER = 1

	State_open_write: INTEGER = 2

end
