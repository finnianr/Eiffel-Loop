note
	description: "[
		A list of substring index intervals conforming to [$source EL_SPLIT_INTERVALS]
		for a string of type [$source STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-06 9:57:56 GMT (Monday 6th March 2023)"
	revision: "16"

class
	EL_SPLIT_STRING_32_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_32]
		undefine
			fill_by_string
		redefine
			is_valid_character
		end

	EL_SPLIT_READABLE_STRING_32_LIST_I [STRING_32]

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if

feature {NONE} -- Implementation

	is_valid_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := True
		end

end