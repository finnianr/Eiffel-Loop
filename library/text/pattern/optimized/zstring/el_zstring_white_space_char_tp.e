note
	description: "Matches white space character in [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 15:46:48 GMT (Saturday 29th October 2022)"
	revision: "8"

class
	EL_ZSTRING_WHITE_SPACE_CHAR_TP

inherit
	EL_WHITE_SPACE_CHAR_TP
		redefine
			i_th_matches
		end

create
	make

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: ZSTRING): BOOLEAN
		-- `True' if i'th character matches pattern
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			Result := c.is_space (text [i]) -- Work around for finalization bug
		end
end