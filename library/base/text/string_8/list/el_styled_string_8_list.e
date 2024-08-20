note
	description: "${STRING_8} implementation of ${EL_STYLED_TEXT_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:22:31 GMT (Tuesday 20th August 2024)"
	revision: "7"

class
	EL_STYLED_STRING_8_LIST

inherit
	EL_STYLED_TEXT_LIST [STRING_8]

create
	make, make_filled, make_from, make_empty, make_from_array, make_regular

convert
	make_regular ({STRING_8})

feature {NONE} -- Implementation

	n_character_string (c: CHARACTER; n: INTEGER): STRING_8
		do
			Result := Character_string_8_table.item (c, 2)
		end

	new_text (text: READABLE_STRING_GENERAL): STRING_8
		do
			Result := text.as_string_8
		end

end