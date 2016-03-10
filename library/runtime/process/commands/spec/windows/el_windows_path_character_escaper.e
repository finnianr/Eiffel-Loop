note
	description: "[
		Characters that have a special meaning for Windows command interprator and should 
		be escaped in path arguments.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-17 15:49:41 GMT (Wednesday 17th December 2014)"
	revision: "2"

class
	EL_WINDOWS_PATH_CHARACTER_ESCAPER

inherit
	EL_CHARACTER_ESCAPER

feature {NONE} -- Implementation

	append_escape_sequence (str: STRING_32; c: CHARACTER_32)
		do
			str.append_character ('^')
			str.append_character (c)
		end

feature {NONE} -- Constants

	Character_intervals: SPECIAL [TUPLE [from_code, to_code: CHARACTER_32]]
		once
			create Result.make_empty (0)
		end

	Characters: STRING_32
		once
			Result := ""
		end

end
