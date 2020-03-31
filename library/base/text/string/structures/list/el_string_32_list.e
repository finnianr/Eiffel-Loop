note
	description: "List of STRING_32 strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-31 11:48:53 GMT (Tuesday 31st March 2020)"
	revision: "9"

class
	EL_STRING_32_LIST

inherit
	EL_STRING_LIST [STRING_32]

create
	make, make_empty, make_with_separator, make_with_lines, make_with_words, make_from_array, make_from_tuple,
	make_from_general, make_with_csv

convert
	make_from_array ({ARRAY [STRING_32]}), make_from_tuple ({TUPLE}), make_with_csv ({STRING_32})
end
