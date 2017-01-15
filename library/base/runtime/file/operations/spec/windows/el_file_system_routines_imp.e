note
	description: "Windows implementation of class `EL_FILE_SYSTEM_ROUTINES_I'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-15 15:44:18 GMT (Sunday 15th January 2017)"
	revision: "2"

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

	modification_time (file_path: EL_FILE_PATH): INTEGER
		local
			info: like File_info
		do
			info := File_info
			info.open (file_path.unicode)
			Result := info.unix_last_write_time
			info.close
		end

feature {NONE} -- Constants

	File_info: EL_WIN_FILE_INFO
		once
			create Result.make
		end

end
