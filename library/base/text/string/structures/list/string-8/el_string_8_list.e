note
	description: "List of strings of type [$source STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-16 9:04:51 GMT (Wednesday 16th August 2023)"
	revision: "18"

class
	EL_STRING_8_LIST

inherit
	EL_STRING_LIST [STRING]
		redefine
			new_string, tab_string
		end

create
	make, make_empty, make_with_lines, make_filled,
	make_from, make_from_array, make_from_tuple, make_from_general,
	make_split, make_adjusted_split, make_word_split, make_comma_split

convert
	make_from_array ({ARRAY [STRING]}), make_comma_split ({STRING}), make_from_tuple ({TUPLE})

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): STRING_8
		do
			Result := general.to_string_8
		end

	tab_string (a_count: INTEGER): STRING_8
		do
			Result := Tab * a_count
		end

end