note
	description: "List of strings of type ${STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-03 10:16:01 GMT (Monday 3rd June 2024)"
	revision: "22"

class
	EL_STRING_8_LIST

inherit
	EL_STRING_LIST [STRING]
		redefine
			add_to_checksum, item_indent, new_string, tab_string
		end

	EL_CHARACTER_8_CONSTANTS

	EL_SHARED_STRING_8_CURSOR

create
	make, make_empty, make_with_lines, make_filled,
	make_from, make_from_substrings, make_from_array, make_from_tuple, make_from_general,
	make_split, make_adjusted_split, make_word_split, make_comma_split

convert
	make_from_array ({ARRAY [STRING]}), make_comma_split ({STRING}), make_from_tuple ({TUPLE})

feature -- Access

	item_indent: INTEGER
		do
			if attached cursor_8 (item) as c8 then
				Result := c8.leading_occurrences ('%T')
			end
		end

feature {NONE} -- Implementation

	add_to_checksum (crc: like crc_generator; str: STRING_8)
		do
			crc.add_string_8 (str)
		end

	new_string (general: READABLE_STRING_GENERAL): STRING_8
		do
			Result := general.to_string_8
		end

	tab_string (a_count: INTEGER): STRING_8
		do
			Result := tab * a_count
		end

end