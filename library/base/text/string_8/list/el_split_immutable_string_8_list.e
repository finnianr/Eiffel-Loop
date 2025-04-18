note
	description: "[
		A list of substring index intervals conforming to ${EL_SPLIT_INTERVALS}
		for a string of type ${IMMUTABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-18 14:56:48 GMT (Friday 18th April 2025)"
	revision: "19"

class
	EL_SPLIT_IMMUTABLE_STRING_8_LIST

inherit
	EL_SPLIT_IMMUTABLE_STRING_LIST [STRING_8, IMMUTABLE_STRING_8]
		rename
			extended_string as super_readable_8
		undefine
			bit_count, same_i_th_character
		redefine
			fill_general, fill_general_by_string, fill_intervals_by_string,
			new_cursor, shared_target_substring
		end

	EL_STRING_BIT_COUNTABLE [IMMUTABLE_STRING_8]

	EL_SHARED_IMMUTABLE_8_MANAGER

create
	make_by_string, make_adjusted, make_adjusted_by_string,
	make_shared_by_string, make_shared_adjusted, make_shared_adjusted_by_string,
	make_empty, make

feature -- Access

	new_cursor: EL_SPLIT_IMMUTABLE_STRING_8_ITERATION_CURSOR
		do
			create Result.make (Current)
		end

feature -- Status query

	is_utf_8_encoded: BOOLEAN
		do
			Result := False
		end

feature -- Element change

	fill_general (a_target: READABLE_STRING_GENERAL; pattern: CHARACTER_32; a_adjustments: INTEGER)
		do
			if attached {like target_string} a_target as l_target then
				fill (l_target, pattern, a_adjustments)

			elseif attached {STRING_8} a_target as str_8 then
				fill (new_shared (str_8), pattern, a_adjustments)
			end
		end

	fill_general_by_string (a_target, pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			if attached {like target_string} a_target as l_target then
				fill_by_string (l_target, pattern, a_adjustments)

			elseif attached {STRING_8} a_target as str_8 then
				fill_by_string (new_shared (str_8), pattern, a_adjustments)
			end
		end

feature {NONE} -- Implementation

	extended_target: EL_EXTENDED_READABLE_STRING_I [CHARACTER]
		do
			Result := super_readable_8 (target_string)
		end

	fill_intervals_by_string (a_target: IMMUTABLE_STRING_8; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			area_intervals.fill_by_string_8 (a_target, delimiter, a_adjustments)
			area := area_intervals.area
		end

	new_shared (a_target: STRING_8): IMMUTABLE_STRING_8
		do
			Result := Immutable_8.new_substring (a_target.area, 0, a_target.count)
		end

	same_i_th_character (a_target: IMMUTABLE_STRING_8; i: INTEGER; uc: CHARACTER_32): BOOLEAN
		do
			Result := a_target [i] = uc.to_character_8
		end

	shared_target_substring (lower, upper: INTEGER): IMMUTABLE_STRING_8
		do
			Result := target_string.shared_substring (lower, upper)
		end

end