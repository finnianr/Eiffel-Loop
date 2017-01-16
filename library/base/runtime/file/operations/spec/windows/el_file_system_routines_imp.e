note
	description: "Windows implementation of class `EL_FILE_SYSTEM_ROUTINES_I'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-16 12:41:42 GMT (Monday 16th January 2017)"
	revision: "3"

class
	EL_FILE_SYSTEM_ROUTINES_IMP

inherit
	EL_FILE_SYSTEM_ROUTINES_I

	EL_OS_IMPLEMENTATION
		rename
			copy as copy_object
		end

feature {NONE} -- Implementation

	escaped_path (a_path: EL_PATH): ZSTRING
		do
			Result := a_path.to_string
			if Result.has (' ') then
				Result.quote (2)
			end
		end

	set_modification_time (file_path: EL_FILE_PATH; date_time: INTEGER)
			-- set modification time with date_time as secs since Unix epoch
		local
			info: like File_info
		do
			info := File_info
			info.open_write (file_path.unicode)
			info.set_unix_last_write_time (date_time)
			info.close
		end

feature {NONE} -- Constants

	File_info: EL_WIN_FILE_INFO
		once
			create Result.make
		end

end
