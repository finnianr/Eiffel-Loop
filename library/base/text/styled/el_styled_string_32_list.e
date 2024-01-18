note
	description: "${STRING_32} implementation of ${EL_STYLED_TEXT_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 13:34:14 GMT (Thursday 17th August 2023)"
	revision: "5"

class
	EL_STYLED_STRING_32_LIST

inherit
	EL_STYLED_TEXT_LIST [STRING_32]

create
	make, make_filled, make_from, make_empty, make_from_array, make_regular

convert
	make_regular ({ZSTRING, STRING_32, STRING_8})

feature {NONE} -- Implementation

	n_character_string (c: CHARACTER; n: INTEGER): STRING_32
		do
			Result := Character_string_32_table.item (c, 2)
		end

	new_text (text: READABLE_STRING_GENERAL): STRING_32
		do
			Result := text.as_string_32
		end

end