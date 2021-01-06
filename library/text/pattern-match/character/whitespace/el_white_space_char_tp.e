note
	description: "White space char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 11:47:19 GMT (Tuesday 5th January 2021)"
	revision: "7"

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