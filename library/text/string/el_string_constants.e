note
	description: "Summary description for {EL_STRING_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_STRING_CONSTANTS

feature {NONE} -- Constants

	Empty_string: ASTRING
		once
			create Result.make_empty
		end

	Empty_string_8: STRING = ""

	Empty_string_32: STRING_32 = ""

invariant
	always_empty: Empty_string.is_empty and Empty_string_8.is_empty and Empty_string_8.is_empty
end
