note
	description: "List of strings of type ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-03 10:24:03 GMT (Monday 3rd June 2024)"
	revision: "29"

class
	EL_ZSTRING_LIST

inherit
	EL_STRING_LIST [ZSTRING]
		rename
			append_code as append_z_code,
			separator_code as separator_z_code
		redefine
			add_to_checksum, append_z_code, item_indent, make_split, proper_cased,
			tab_string, separator_z_code
		end

	EL_SHARED_ZSTRING_CODEC

	EL_CHARACTER_32_CONSTANTS

create
	make, make_empty, make_with_lines, make_filled,
	make_from, make_from_substrings, make_from_if, make_from_array, make_from_list,
	make_from_tuple, make_from_general, make_split, make_adjusted_split, make_word_split, make_comma_split

convert
	make_from_array ({ARRAY [ZSTRING]}), make_comma_split ({STRING, STRING_32, ZSTRING}), make_from_tuple ({TUPLE})

feature {NONE} -- Initialization

	make_split (general: READABLE_STRING_GENERAL; delimiter: CHARACTER_32)
		do
			if attached {ZSTRING} general as zstr then
				make_from_special (zstr.split_list (delimiter).area_v2)
			else
				Precursor (general, delimiter)
			end
		end

feature -- Access

	item_indent: INTEGER
		do
			Result := item.leading_occurrences ('%T')
		end

feature -- Element change

	expand_tabs (space_count: INTEGER)
		-- Expand tab characters as `space_count' spaces
		do
			do_all (agent {ZSTRING}.expand_tabs (space_count))
		end

feature {NONE} -- Implementation

	add_to_checksum (crc: like crc_generator; str: ZSTRING)
		do
			crc.add_string (str)
		end

	append_z_code (str: ZSTRING; z_code: NATURAL)
		do
			str.append_z_code (z_code)
		end

	proper_cased (word: ZSTRING): ZSTRING
		do
			Result := word.as_proper_case
		end

	separator_z_code (a_separator: CHARACTER_32): NATURAL
		do
			Result := codec.as_z_code (a_separator)
		end

	tab_string (n: INTEGER): ZSTRING
		do
			Result := tab * n
		end

end