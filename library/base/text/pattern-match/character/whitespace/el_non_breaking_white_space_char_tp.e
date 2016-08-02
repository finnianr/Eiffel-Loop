note
	description: "Summary description for {EL_NON_BREAKING_WHITE_SPACE_CHAR_TP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 18:52:39 GMT (Saturday 26th December 2015)"
	revision: "1"

class
	EL_NON_BREAKING_WHITE_SPACE_CHAR_TP

inherit
	EL_WHITE_SPACE_CHAR_TP
		redefine
			name, code_matches
		end

create
	make

feature -- Access

	name: STRING
		do
			Result := "non_breaking_" + Precursor
		end

feature {NONE} -- Implementation

	code_matches (code: NATURAL): BOOLEAN
		do
			Result := Precursor (code) and then not (code = 10 or code = 13)
		end

end