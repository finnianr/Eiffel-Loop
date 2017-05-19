note
	description: "Summary description for {EL_ZSTRING_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-17 15:41:03 GMT (Wednesday 17th May 2017)"
	revision: "2"

class
	EL_ZSTRING_LIST

inherit
	EL_STRING_LIST [ZSTRING]
		redefine
			proper_cased, tab_string
		end

create
	make, make_empty, make_with_separator, make_with_lines, make_with_words, make_from_array

convert
	make_from_array ({ARRAY [ZSTRING]}), make_with_words ({ZSTRING})

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
