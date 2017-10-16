note
	description: "Summary description for {EL_NON_BREAKING_WHITE_SPACE_CHAR_TP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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