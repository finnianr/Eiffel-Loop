note
	description: "List of strings of type ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 9:46:32 GMT (Monday 5th May 2025)"
	revision: "25"

class
	EL_STRING_32_LIST

inherit
	EL_STRING_LIST [STRING_32]
		redefine
			add_to_checksum, item_indent, new_string, tab_string
		end

	EL_CHARACTER_32_CONSTANTS

create
	make, make_empty, make_with_lines, make_filled, make_from_special,
	make_from, make_from_substrings, make_from_array, make_from_iterable,
	make_from_tuple, make_from_general, make_paragraphs,
	make_split, make_adjusted_split, make_word_split, make_comma_split

convert
	make_from_array ({ARRAY [STRING_32]}), make_from_tuple ({TUPLE}), make_comma_split ({STRING_32})

feature -- Access

	item_indent: INTEGER
		do
			Result := super_32 (item).leading_occurrences ('%T')
		end

feature {NONE} -- Implementation

	add_to_checksum (crc: like crc_generator; str: STRING_32)
		do
			crc.add_string_32 (str)
		end

	new_string (general: READABLE_STRING_GENERAL): STRING_32
		do
			Result := general.to_string_32
		end

	tab_string (a_count: INTEGER): STRING_32
		do
			Result := tab.as_string_32 (a_count)
		end
end