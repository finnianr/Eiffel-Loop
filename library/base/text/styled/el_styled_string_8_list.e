note
	description: "[$source STRING_8] implementation of [$source EL_STYLED_TEXT_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 17:56:42 GMT (Tuesday 2nd March 2021)"
	revision: "2"

class
	EL_STYLED_STRING_8_LIST

inherit
	EL_STYLED_TEXT_LIST [STRING_8]
		redefine
			ellipsis
		end

create
	make, make_filled, make_from_list, make_empty, make_from_array, make_regular

convert
	make_regular ({STRING_8})

feature {NONE} -- Implementation

	n_character_string (c: CHARACTER; n: INTEGER): STRING_8
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.n_character_string (c, 2)
		end

	new_text (text: READABLE_STRING_GENERAL): STRING_8
		do
			Result := text.as_string_8
		end

feature -- Constants

	Ellipsis: STRING_8
		once
			Result := n_character_string ('.', 2)
		end
end