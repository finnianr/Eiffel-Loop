note
	description: "Unix implementation of class `EL_FILE_SYSTEM_ROUTINES_I'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-15 14:45:42 GMT (Sunday 15th January 2017)"
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

	escaped_path (path: EL_PATH): ZSTRING
		do
			Result := path.to_string
			Result.escape (Path_escaper)
		end

	modification_time (file_path: EL_FILE_PATH): INTEGER
		do
			Result := closed_raw_file (file_path).date
		end

feature {NONE} -- Constants

	Path_escaper: EL_ZSTRING_BASH_PATH_CHARACTER_ESCAPER
		once
			create Result
		end
end
