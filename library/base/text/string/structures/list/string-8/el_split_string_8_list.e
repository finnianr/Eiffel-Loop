note
	description: "[
		A list of substring index intervals conforming to ${EL_SPLIT_INTERVALS}
		for a string of type ${STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "24"

class
	EL_SPLIT_STRING_8_LIST

inherit
	EL_SPLIT_STRING_LIST [STRING_8]
		undefine
			bit_count
		redefine
			default_target, new_intervals, same_i_th_character, trim_string
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

	new_intervals: EL_STRING_8_SPLIT_INTERVALS
		do
			create Result.make_empty
		end

	same_i_th_character (a_target: STRING_8; i: INTEGER; uc: CHARACTER_32): BOOLEAN
		do
			Result := a_target [i] = uc.to_character_8
		end

end