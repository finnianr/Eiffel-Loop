note
	description: "Windows implementation of class `EL_FILE_SYSTEM_ROUTINES_I'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-03 9:41:06 GMT (Monday 3rd October 2016)"
	revision: "1"

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

end
