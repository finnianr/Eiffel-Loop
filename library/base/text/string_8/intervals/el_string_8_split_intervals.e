note
	description: "[
		${EL_SPLIT_INTERVALS} optimized for strings conforming to ${READABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:08:32 GMT (Tuesday 20th August 2024)"
	revision: "7"

class
	EL_STRING_8_SPLIT_INTERVALS

inherit
	EL_SPLIT_INTERVALS
		undefine
			fill_by_string_general, fill_by_string_8, make_by_string
		redefine
			is_white_space
		end

	EL_STRING_8_OCCURRENCE_INTERVALS
		undefine
			extend_buffer
		end

create
	make, make_adjusted, make_empty, make_by_string, make_sized, make_from_special

feature {NONE} -- Implementation

	is_white_space (a_target: READABLE_STRING_8; i: INTEGER): BOOLEAN
		do
			Result := a_target [i].is_space
		end

end