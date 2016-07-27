note
	description: "[
		Characters that have a special meaning for Windows command interprator and should 
		be escaped in path arguments.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-30 17:56:59 GMT (Wednesday 30th March 2016)"
	revision: "3"

class
	EL_WINDOWS_PATH_CHARACTER_ESCAPER

inherit
	EL_CHARACTER_ESCAPER [STRING_32]

feature {NONE} -- Implementation

	append_escape_sequence (str: STRING_32; code: NATURAL)
		do
			str.append_character ('^')
			str.append_code (code)
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