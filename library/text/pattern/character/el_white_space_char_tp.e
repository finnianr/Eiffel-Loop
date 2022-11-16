note
	description: "Matches white space character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_WHITE_SPACE_CHAR_TP

inherit
	EL_CHARACTER_PROPERTY_TP
		rename
			name_inserts as Empty_inserts
		end

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if i'th character matches pattern
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			Result := c.is_space (text [i]) -- Work around for finalization bug
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "whitespace character"
		end
end