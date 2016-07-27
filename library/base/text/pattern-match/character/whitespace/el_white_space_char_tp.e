note
	description: "Summary description for {EL_WHITE_SPACE_CHAR_TP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 18:38:48 GMT (Saturday 26th December 2015)"
	revision: "5"

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
		do
			Result := code.to_character_32.is_space
		end

end