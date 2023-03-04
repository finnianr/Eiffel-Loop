note
	description: "[
		A virtual split-list of [$source STRING_32] represented as an array of [$INTEGER_64] intervals
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-04 9:54:15 GMT (Saturday 4th March 2023)"
	revision: "15"

class
	EL_SPLIT_STRING_32_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_32]
		redefine
			is_valid_character
		end

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if

feature {NONE} -- Implementation

	is_valid_character (uc: CHARACTER_32): BOOLEAN
		do
			Result := True
		end

end