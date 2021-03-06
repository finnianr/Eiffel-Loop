note
	description: "Alphabetical character text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-05 11:40:29 GMT (Tuesday 5th January 2021)"
	revision: "6"

class
	EL_ALPHA_CHAR_TP

inherit
	EL_SINGLE_CHAR_TEXT_PATTERN
		rename
			make_default as make
		end

create
	make

feature -- Access

	name: STRING
		do
			Result := "letter"
		end

feature {NONE} -- Implementation

	match_count (text: EL_STRING_VIEW): INTEGER
		do
			if text.count > 0 and then code_matches (text.code (1)) then
				Result := 1
			else
				Result := Match_fail
			end
		end

	code_matches (code: NATURAL): BOOLEAN
		do
			Result := code.to_character_32.is_alpha
		end

end