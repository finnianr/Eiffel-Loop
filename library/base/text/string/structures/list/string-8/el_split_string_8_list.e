note
	description: "[
		A list of substring index intervals conforming to ${EL_SPLIT_INTERVALS}
		for a string of type ${STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-14 18:07:04 GMT (Sunday 14th April 2024)"
	revision: "25"

class
	EL_SPLIT_STRING_8_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_8]
		undefine
			bit_count
		redefine
			default_target, fill_intervals_by_string, same_i_th_character, trim_string
		end

	EL_STRING_8_BIT_COUNTABLE [STRING_8]

	EL_STRING_8_CONSTANTS

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string,
	make_from_for, make_from, make_from_if

feature -- Element change

	trim_string
		do
			target_string.trim
		end

feature {NONE} -- Implementation

	default_target: STRING_8
		do
			Result := Empty_string_8
		end

	fill_intervals_by_string (a_target: STRING_8; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			area_intervals.fill_by_string_8 (a_target, delimiter, a_adjustments)
			area := area_intervals.area
		end

	same_i_th_character (a_target: STRING_8; i: INTEGER; uc: CHARACTER_32): BOOLEAN
		do
			Result := a_target [i] = uc.to_character_8
		end

end