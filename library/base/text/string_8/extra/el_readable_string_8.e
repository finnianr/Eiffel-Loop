note
	description: "Extends the features of strings conforming to ${READABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-11 15:15:31 GMT (Friday 11th April 2025)"
	revision: "3"

class
	EL_READABLE_STRING_8

inherit
	EL_EXTENDED_READABLE_STRING_8
		rename
			empty_string_8 as empty_target
		end

	STRING_8_ITERATION_CURSOR
		rename
			area_first_index as index_lower,
			area_last_index as index_upper,
			make as set_target
		end

	EL_STRING_BIT_COUNTABLE [READABLE_STRING_8]

create
	make_empty

feature {NONE} -- Implementation

	new_readable: EL_READABLE_STRING_8
		do
			create Result.make_empty
		end

	other_area (other: READABLE_STRING_8): like area
		do
			Result := other.area
		end

	other_index_lower (other: READABLE_STRING_8): INTEGER
		do
			Result := other.area_lower
		end

end