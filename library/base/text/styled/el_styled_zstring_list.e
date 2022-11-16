note
	description: "Implementation of [$source EL_STYLED_TEXT_LIST [EL_ZSTRING]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_STYLED_ZSTRING_LIST

inherit
	EL_STYLED_TEXT_LIST [ZSTRING]
		redefine
			ellipsis
		end

create
	make, make_filled, make_from, make_empty, make_from_array, make_regular

convert
	make_regular ({ZSTRING, STRING_32, STRING_8})

feature {NONE} -- Implementation

	n_character_string (c: CHARACTER; n: INTEGER): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := s.n_character_string (c, 2)
		end

	new_text (text: READABLE_STRING_GENERAL): ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := s.as_zstring (text)
		end

feature -- Constants

	Ellipsis: ZSTRING
		once
			Result := n_character_string ('.', 2)
		end
end