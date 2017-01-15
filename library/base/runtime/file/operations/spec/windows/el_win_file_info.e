note
	description: "Access file time information using Windows system call GetFileTime"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-15 15:43:23 GMT (Sunday 15th January 2017)"
	revision: "1"

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
			open: is_open
		do
			Result := Time_creation.since_unix_epoch
		end

	unix_last_access_time: INTEGER
		require
			open: is_open
		do
			Result := Time_last_access.since_unix_epoch
		end

	unix_last_write_time: INTEGER
		require
			open: is_open
		do
			Result := Time_last_write.since_unix_epoch
		end

feature -- Element change

	open (file_path: READABLE_STRING_GENERAL)
		local
			success: BOOLEAN
		do
			if is_open then
				close
			end
			internal_name := File_info.file_name_to_pointer (file_path, internal_name)
			handle := c_open_file (internal_name.item)
			if is_open then
				success := c_get_file_time (handle, Time_creation.item, Time_last_access.item, Time_last_write.item)
			else
				internal_name := Default_internal_name
			end
		end

feature -- Status query

	is_open: BOOLEAN
		do
			Result := handle /= default_handle
		end

feature -- Status change

	close
		do
			if is_open and then c_close_file (handle) then
				handle := default_handle
				internal_name := Default_internal_name
			end
		ensure
			closed: not is_open
		end

feature {NONE} -- Internal attributes

	internal_name: MANAGED_POINTER

	handle: NATURAL

feature {NONE} -- Constants

	Time_creation: EL_WIN_FILE_DATE_TIME
		once
			create Result.make
		end

	Time_last_access: EL_WIN_FILE_DATE_TIME
		once
			create Result.make
		end

	Time_last_write: EL_WIN_FILE_DATE_TIME
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

end
