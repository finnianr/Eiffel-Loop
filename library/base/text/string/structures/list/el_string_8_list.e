note
	description: "List of [$source STRING_8] strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "15"

class
	EL_STRING_8_LIST

inherit
	EL_STRING_LIST [STRING]

create
	make, make_empty, make_with_lines, make_filled,
	make_from, make_from_array, make_from_tuple, make_from_general,
	make_split, make_adjusted_split, make_word_split, make_comma_split

convert
	make_from_array ({ARRAY [STRING]}), make_comma_split ({STRING}), make_from_tuple ({TUPLE})
end