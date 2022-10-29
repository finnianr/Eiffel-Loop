note
	description: "Matches white space character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 7:17:49 GMT (Saturday 29th October 2022)"
	revision: "8"

class
	EL_WHITE_SPACE_CHAR_TP

inherit
	EL_CHARACTER_PROPERTY_TP
		rename
			make_default as make
		end
		
create
	make

feature -- Access

	name: STRING
		do
			Result := "white_space_character"
		end

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if i'th character matches pattern
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			Result := c.is_space (text [i]) -- Work around for finalization bug
		end
end