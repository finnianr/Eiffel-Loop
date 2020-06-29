note
	description: "Windows implementation of class [$source EL_FILE_SYSTEM_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-28 9:15:11 GMT (Sunday 28th June 2020)"
	revision: "10"

class
	EL_FILE_SYSTEM_ROUTINES_IMP

inherit
	EL_FILE_SYSTEM_ROUTINES_I

	EL_OS_IMPLEMENTATION
		rename
			copy as copy_object
		end

	EL_MODULE_ZSTRING
		rename
			copy as copy_object
		end

create
	make

feature {NONE} -- Implementation

	escaped_path (path: READABLE_STRING_GENERAL): ZSTRING
		local
			l_path: ZSTRING
		do
			l_path := Zstring.as_zstring (path)
			if l_path.has (' ') then
				Result := l_path.quoted (2)
			else
				Result := l_path
			end
		end

	set_file_stamp (file_path: EL_FILE_PATH; date_time: INTEGER)
			-- Stamp file with `time' (for both access and modification).
		local
			info: like File_info
		do
			info := File_info
			info.open_write (file_path)
			info.set_unix_last_access_time (date_time)
			info.set_unix_last_write_time (date_time)
			info.close
		end

	set_file_modification_time (file_path: EL_FILE_PATH; date_time: INTEGER)
			-- set modification time with date_time as secs since Unix epoch
		local
			info: like File_info
		do
			info := File_info
			info.open_write (file_path)
			info.set_unix_last_write_time (date_time)
			info.close
		end

feature {NONE} -- Constants

	File_info: EL_WIN_FILE_INFO
		once
			create Result.make
		end

end
