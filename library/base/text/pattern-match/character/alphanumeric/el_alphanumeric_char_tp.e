note
	description: "Summary description for {EL_ALPHANUMERIC_CHAR_TP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 13:34:09 GMT (Saturday 26th December 2015)"
	revision: "1"

class
	EL_ALPHANUMERIC_CHAR_TP

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
			Result := "alphanumeric"
		end

feature {NONE} -- Implementation

	code_matches (code: NATURAL): BOOLEAN
		do
			Result := code.to_character_32.is_alpha_numeric
		end
end