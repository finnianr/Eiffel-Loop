note
	description: "Implementation of [$source EL_STYLED_TEXT_LIST [ZSTRING]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 21:19:31 GMT (Thursday 17th August 2023)"
	revision: "8"

class
	EL_STYLED_ZSTRING_LIST

inherit
	EL_STYLED_TEXT_LIST [ZSTRING]

	EL_STRING_GENERAL_ROUTINES
		rename
			as_zstring as new_text
		end

create
	make, make_filled, make_from, make_empty, make_from_array, make_regular

convert
	make_regular ({ZSTRING, STRING_32, STRING_8})

feature {NONE} -- Implementation

	n_character_string (c: CHARACTER; n: INTEGER): ZSTRING
		do
			Result := Character_string_table.item (c, 2)
		end

end