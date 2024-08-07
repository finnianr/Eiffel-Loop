note
	description: "[
		${EL_SPLIT_INTERVALS} optimized for strings of type ${ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-14 18:17:45 GMT (Sunday 14th April 2024)"
	revision: "6"

class
	EL_ZSTRING_SPLIT_INTERVALS

inherit
	EL_SPLIT_INTERVALS
		undefine
			fill_by_string_general, make_by_string
		redefine
			is_white_space
		end

	EL_ZSTRING_OCCURRENCE_INTERVALS
		undefine
			extend_buffer
		end

create
	make, make_adjusted, make_empty, make_by_string, make_sized, make_from_special

feature {NONE} -- Implementation

	is_white_space (a_target: ZSTRING; i: INTEGER): BOOLEAN
		do
			Result := a_target.is_space_item (i)
		end

end