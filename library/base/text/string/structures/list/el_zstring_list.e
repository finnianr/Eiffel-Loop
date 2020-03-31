note
	description: "List of [$source EL_ZSTRING] strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-31 11:48:25 GMT (Tuesday 31st March 2020)"
	revision: "10"

class
	EL_ZSTRING_LIST

inherit
	EL_STRING_LIST [ZSTRING]
		redefine
			proper_cased, tab_string
		end

create
	make, make_empty, make_with_separator, make_with_lines, make_from_list, make_with_words,
	make_from_array, make_from_tuple, make_from_general, make_filled, make_with_csv

convert
	make_from_array ({ARRAY [ZSTRING]}), make_with_csv ({STRING}), make_from_tuple ({TUPLE})

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

	proper_cased (word: like item): like item
		do
			Result := word.as_proper_case
		end

	tab_string (a_count: INTEGER): ZSTRING
		do
			create Result.make_filled (Tabulation.to_character_8, a_count)
		end

end
