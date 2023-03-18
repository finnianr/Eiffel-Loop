note
	description: "[
		A list of substring index intervals conforming to [$source EL_SPLIT_INTERVALS]
		for a string of type [$source STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-18 9:52:03 GMT (Saturday 18th March 2023)"
	revision: "19"

class
	EL_SPLIT_STRING_8_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_8]
		undefine
			fill_by_string, is_valid_character, is_white_space, same_i_th_character, shared_cursor
		redefine
			default_target, target
		end

	EL_STRING_8_OCCURRENCE_IMPLEMENTATION [STRING_8]

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if

feature {NONE} -- Implementation

	default_target: STRING_8
		do
			Result := Empty_string_8
		end

feature {NONE} -- Internal attributes

	target: STRING_8
end