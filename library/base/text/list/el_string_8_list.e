note
	description: "String 8 list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 10:57:59 GMT (Monday 12th November 2018)"
	revision: "7"

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
