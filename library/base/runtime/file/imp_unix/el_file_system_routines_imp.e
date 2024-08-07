note
	description: "Unix implementation of class ${EL_FILE_SYSTEM_ROUTINES_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-22 5:26:20 GMT (Saturday 22nd June 2024)"
	revision: "21"

class
	EL_FILE_SYSTEM_ROUTINES_IMP

inherit
	EL_FILE_SYSTEM_ROUTINES_I

	EL_UNIX_IMPLEMENTATION

	EL_SHARED_ESCAPE_TABLE

feature {NONE} -- Implementation

	escaped_path (path: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := Path_escaper.escaped (as_zstring (path), True)
		end

feature {NONE} -- Constants

	Path_escaper: EL_STRING_ESCAPER [ZSTRING]
		once
			create Result.make (Escape_table.Bash)
		end

end