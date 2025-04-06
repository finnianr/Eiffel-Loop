note
	description: "[
		A list of substring index intervals conforming to ${EL_SPLIT_INTERVALS}
		for a string of type ${STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-06 7:07:16 GMT (Sunday 6th April 2025)"
	revision: "26"

class
	EL_SPLIT_STRING_32_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_32]
		undefine
			bit_count
		redefine
			default_target, extended_string, fill_intervals_by_string, trim_string
		end

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

	EL_STRING_32_CONSTANTS

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if

feature -- Element change

	trim_string
		do
			target_string.trim
		end

feature {NONE} -- Implementation

	default_target: STRING_32
		do
			Result := Empty_string_32
		end

	extended_string (str_32: STRING_32): like super_readable_32
		do
			Result := super_readable_32 (str_32)
		end

	fill_intervals_by_string (a_target: STRING_32; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			area_intervals.fill_by_string_32 (a_target, delimiter, a_adjustments)
			area := area_intervals.area
		end

end