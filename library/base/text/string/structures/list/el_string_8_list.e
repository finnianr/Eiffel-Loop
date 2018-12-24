note
	description: "List of `STRING_8' strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-17 19:02:45 GMT (Monday 17th December 2018)"
	revision: "8"

class
	EL_STRING_8_LIST

inherit
	EL_STRING_LIST [STRING]

create
	make, make_empty, make_with_separator, make_with_lines, make_with_words, make_from_array, make_from_tuple,
	make_from_general

convert
	make_from_array ({ARRAY [STRING]}), make_with_words ({STRING}), make_from_tuple ({TUPLE})
end
