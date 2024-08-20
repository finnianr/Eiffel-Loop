note
	description: "Implementation of ${EL_STYLED_TEXT_LIST [ZSTRING]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:22:52 GMT (Tuesday 20th August 2024)"
	revision: "11"

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