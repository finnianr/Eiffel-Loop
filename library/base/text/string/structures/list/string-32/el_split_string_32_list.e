note
	description: "[
		A list of substring index intervals conforming to [$source EL_SPLIT_INTERVALS]
		for a string of type [$source STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-15 15:15:26 GMT (Wednesday 15th March 2023)"
	revision: "18"

class
	EL_SPLIT_STRING_32_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_32]
		undefine
			fill_by_string, is_valid_character
		redefine
			default_target
		end

	EL_STRING_32_OCCURRENCE_IMPLEMENTATION [STRING_32]

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if

feature {NONE} -- Implementation

	default_target: STRING_32
		do
			Result := Empty_string_32
		end

end