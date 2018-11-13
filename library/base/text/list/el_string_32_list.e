note
	description: "List of STRING_32 strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 10:57:50 GMT (Monday 12th November 2018)"
	revision: "7"

class
	EL_STRING_32_LIST

inherit
	EL_STRING_LIST [STRING_32]

create
	make, make_empty, make_with_separator, make_with_lines, make_with_words, make_from_array, make_from_tuple,
	make_from_general

convert
	make_from_array ({ARRAY [STRING_32]}), make_with_words ({STRING_32}), make_from_tuple ({TUPLE})
end
