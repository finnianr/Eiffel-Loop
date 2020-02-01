note
	description: "White space char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 17:22:00 GMT (Saturday 1st February 2020)"
	revision: "6"

class
	EL_WHITE_SPACE_CHAR_TP

inherit
	EL_ALPHA_CHAR_TP
		redefine
			name, code_matches
		end

	EL_MODULE_CHAR_32

create
	make

feature -- Access

	name: STRING
		do
			Result := "white_space_character"
		end

feature {NONE} -- Implementation

	code_matches (code: NATURAL): BOOLEAN
		do
			Result := Char_32.is_space (code.to_character_32) -- Work around for finalization bug
		end

end
