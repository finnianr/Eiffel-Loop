note
	description: "Summary description for {EL_DO_NOTHING_CHARACTER_ESCAPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_DO_NOTHING_CHARACTER_ESCAPER

inherit
	EL_CHARACTER_ESCAPER

feature {NONE} -- Implementation

	append_escape_sequence (str: STRING_32; c: CHARACTER_32)
		do
		end

feature {NONE} -- Constants

	Character_intervals: SPECIAL [TUPLE [from_code, to_code: CHARACTER_32]]
		once
			create Result.make_empty (0)
		end

	Characters: STRING_32
		once
			create Result.make_empty
		end
end
