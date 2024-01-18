note
	description: "List of strings of type ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 7:26:56 GMT (Thursday 17th August 2023)"
	revision: "17"

class
	EL_STRING_32_LIST

inherit
	EL_STRING_LIST [STRING_32]
		redefine
			item_indent, new_string, tab_string
		end

	EL_SHARED_STRING_32_CURSOR

	EL_CHARACTER_32_CONSTANTS

create
	make, make_empty, make_with_lines, make_filled,
	make_from, make_from_array, make_from_tuple, make_from_general,
	make_split, make_adjusted_split, make_word_split, make_comma_split

convert
	make_from_array ({ARRAY [STRING_32]}), make_from_tuple ({TUPLE}), make_comma_split ({STRING_32})

feature -- Access

	item_indent: INTEGER
		do
			if attached cursor_32 (item) as c32 then
				Result := c32.leading_occurrences ('%T')
			end
		end

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): STRING_32
		do
			Result := general.to_string_32
		end

	tab_string (a_count: INTEGER): STRING_32
		do
			Result := tab.as_string_32 (a_count)
		end
end