note
	description: "Matches white space character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EL_WHITE_SPACE_CHAR_TP

inherit
	EL_ALPHA_CHAR_TP
		redefine
			name, code_matches
		end

create
	make

feature -- Access

	name: STRING
		do
			Result := "white_space_character"
		end

feature {NONE} -- Implementation

	code_matches (code: NATURAL): BOOLEAN
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			Result := c.is_space (code.to_character_32) -- Work around for finalization bug
		end

end