note
	description: "Extends the features of strings conforming to ${READABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-11 15:16:44 GMT (Friday 11th April 2025)"
	revision: "3"

class
	EL_READABLE_STRING_32

inherit
	EL_EXTENDED_READABLE_STRING_32
		rename
			empty_target as empty_string_32
		end

	STRING_32_ITERATION_CURSOR
		rename
			area_first_index as index_lower,
			area_last_index as index_upper,
			make as set_target
		end

	EL_STRING_BIT_COUNTABLE [READABLE_STRING_32]

	EL_STRING_32_CONSTANTS

create
	make_empty

feature {NONE} -- Implementation

	new_readable: EL_READABLE_STRING_32
		do
			create Result.make_empty
		end

	other_area (other: READABLE_STRING_32): like area
		do
			Result := other.area
		end

	other_index_lower (other: READABLE_STRING_32): INTEGER
		do
			Result := other.area_lower
		end

end