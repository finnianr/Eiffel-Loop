note
	description: "Windows implementation of class [$source EL_FILE_SYSTEM_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 7:45:16 GMT (Monday 7th February 2022)"
	revision: "13"

class
	EL_FILE_SYSTEM_ROUTINES_IMP

inherit
	EL_FILE_SYSTEM_ROUTINES_I

	EL_OS_IMPLEMENTATION
		rename
			copy as copy_object
		end

feature {NONE} -- Implementation

	escaped_path (path: READABLE_STRING_GENERAL): ZSTRING
		local
			l_path: ZSTRING; s: EL_ZSTRING_ROUTINES
		do
			l_path := s.as_zstring (path)
			if l_path.has (' ') then
				Result := l_path.quoted (2)
			else
				Result := l_path
			end
		end

end