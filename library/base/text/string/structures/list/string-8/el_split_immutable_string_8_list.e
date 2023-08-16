note
	description: "[
		A list of substring index intervals conforming to [$source EL_SPLIT_INTERVALS]
		for a string of type [$source IMMUTABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 6:16:18 GMT (Monday 7th August 2023)"
	revision: "14"

class
	EL_SPLIT_IMMUTABLE_STRING_8_LIST

inherit
	EL_SPLIT_IMMUTABLE_STRING_LIST [STRING_8, IMMUTABLE_STRING_8]
		undefine
			bit_count, same_i_th_character
		redefine
			fill_general, fill_general_by_string, new_intervals, shared_target_substring, shared_cursor
		end

	EL_STRING_BIT_COUNTABLE [IMMUTABLE_STRING_8]

	EL_SHARED_IMMUTABLE_8_MANAGER

	EL_SHARED_STRING_8_CURSOR

create
	make_by_string, make_adjusted, make_adjusted_by_string,
	make_shared_by_string, make_shared_adjusted, make_shared_adjusted_by_string,
	make_empty, make

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

	new_intervals: EL_STRING_8_SPLIT_INTERVALS
		do
			create Result.make_empty
		end

	new_shared (a_target: STRING_8): IMMUTABLE_STRING_8
		do
			Result := Immutable_8.new_substring (a_target.area, 0, a_target.count)
		end

	same_i_th_character (a_target: IMMUTABLE_STRING_8; i: INTEGER; uc: CHARACTER_32): BOOLEAN
		do
			Result := a_target [i] = uc.to_character_8
		end

	shared_cursor: EL_STRING_8_ITERATION_CURSOR
		do
			Result := cursor_8 (target_string)
		end

	shared_target_substring (lower, upper: INTEGER): IMMUTABLE_STRING_8
		do
			Result := target_string.shared_substring (lower, upper)
		end

end