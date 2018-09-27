note
	description: "Non breaking white space char tp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

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