note
	description: "Unix implementation of class [$source EL_FILE_SYSTEM_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 10:50:27 GMT (Thursday 5th January 2023)"
	revision: "15"

class
	EL_FILE_SYSTEM_ROUTINES_IMP

inherit
	EL_FILE_SYSTEM_ROUTINES_I

	EL_OS_IMPLEMENTATION
		rename
			copy as copy_object
		end

	EL_SHARED_ESCAPE_TABLE
		rename
			copy as copy_object
		end

feature {NONE} -- Implementation

	escaped_path (path: READABLE_STRING_GENERAL): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := Path_escaper.escaped (s.as_zstring (path), True)
		end

feature {NONE} -- Constants

	Path_escaper: EL_STRING_ESCAPER [ZSTRING]
		once
			create Result.make (Escape_table.Bash)
		end

end