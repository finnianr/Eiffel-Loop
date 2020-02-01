note
	description: "Numeric char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 19:22:26 GMT (Saturday 1st February 2020)"
	revision: "6"

class
	EL_NUMERIC_CHAR_TP

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
			Result := "digit"
		end

feature {NONE} -- Implementation

	code_matches (code: NATURAL): BOOLEAN
		do
			Result := Char_32.is_digit (code.to_character_32)
		end
end
