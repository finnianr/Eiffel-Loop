note
	description: "[
		Characters that have a special meaning for BASH interprator and should be escaped in path arguments
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_BASH_PATH_CHARACTER_ESCAPER

inherit
	EL_CHARACTER_ESCAPER

feature {NONE} -- Implementation

	append_escape_sequence (str: STRING_32; c: CHARACTER_32)
		do
			str.append_character ('\')
			str.append_character (c)
		end

feature {NONE} -- Constants

	Character_intervals: SPECIAL [TUPLE [from_code, to_code: CHARACTER_32]]
		once
			create Result.make_empty (0)
		end

	Characters: STRING_32
		once
			Result := "`$%"\"
		end

end
