note
	description: "List of [$source EL_ZSTRING] strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-19 18:13:29 GMT (Friday 19th March 2021)"
	revision: "12"

class
	EL_ZSTRING_LIST

inherit
	EL_STRING_LIST [ZSTRING]
		rename
			append_code as append_z_code,
			separator_code as separator_z_code
		redefine
			append_z_code, proper_cased, tab_string, separator_z_code
		end

	EL_SHARED_ZSTRING_CODEC

create
	make, make_empty, make_with_separator, make_with_lines, make_from_list, make_with_words,
	make_from_array, make_from_tuple, make_from_general, make_filled, make_with_csv

convert
	make_from_array ({ARRAY [ZSTRING]}), make_with_csv ({STRING, STRING_32, ZSTRING}), make_from_tuple ({TUPLE})

feature -- Element change

	expand_tabs (space_count: INTEGER)
			-- Expand tab characters as `space_count' spaces
		local
			l_index: INTEGER; tab, spaces: ZSTRING
		do
			l_index := index
			tab := tab_string (1); create spaces.make_filled (' ', space_count)
			from start until after loop
				item.replace_substring_all (tab, spaces)
				forth
			end
			index := l_index
		end

feature {NONE} -- Implementation

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

	tab_string (a_count: INTEGER): ZSTRING
		do
			create Result.make_filled (Tabulation.to_character_8, a_count)
		end

end