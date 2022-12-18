note
	description: "List of STRING_32 strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-18 18:10:55 GMT (Sunday 18th December 2022)"
	revision: "14"

class
	EL_STRING_32_LIST

inherit
	EL_STRING_LIST [STRING_32]
		redefine
			tab_string
		end

create
	make, make_empty, make_with_lines, make_filled,
	make_from, make_from_array, make_from_tuple, make_from_general,
	make_split, make_adjusted_split, make_word_split, make_comma_split

convert
	make_from_array ({ARRAY [STRING_32]}), make_from_tuple ({TUPLE}), make_comma_split ({STRING_32})

feature {NONE} -- Implementation

	tab_string (a_count: INTEGER): STRING_32
		local
			s: EL_STRING_32_ROUTINES
		do
			Result := s.n_character_string ('%T', a_count)
		end
end