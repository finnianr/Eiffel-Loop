note
	description: "Non breaking white space z char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_NON_BREAKING_WHITE_SPACE_Z_CHAR_TP

inherit
	EL_NON_BREAKING_WHITE_SPACE_CHAR_TP
		redefine
			code_matches
		select
			code_matches
		end

	EL_WHITE_SPACE_Z_CHAR_TP
		rename
			code_matches as z_code_matches_white_space
		undefine
			name
		end

create
	make

feature {NONE} -- Implementation

	code_matches (z_code: NATURAL): BOOLEAN
		do
			Result := z_code_matches_white_space (z_code) and then not (z_code = 10 or else z_code = 13)
		end
end