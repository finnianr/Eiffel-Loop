note
	description: "[
		A list of substring index intervals conforming to ${EL_SPLIT_INTERVALS}
		for a string of type ${IMMUTABLE_STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-14 18:07:04 GMT (Sunday 14th April 2024)"
	revision: "16"

class
	EL_SPLIT_IMMUTABLE_STRING_32_LIST

inherit
	EL_SPLIT_IMMUTABLE_STRING_LIST [STRING_32, IMMUTABLE_STRING_32]
		undefine
			bit_count
		redefine
			fill_general, fill_general_by_string, fill_intervals_by_string,
			shared_target_substring, shared_cursor
		end

	EL_STRING_BIT_COUNTABLE [IMMUTABLE_STRING_32]

	EL_SHARED_IMMUTABLE_32_MANAGER

	EL_SHARED_STRING_32_CURSOR

create
	make_by_string, make_adjusted, make_adjusted_by_string,
	make_shared_by_string, make_shared_adjusted, make_shared_adjusted_by_string,
	make_empty, make

feature -- Element change

	fill_general (a_target: READABLE_STRING_GENERAL; pattern: CHARACTER_32; a_adjustments: INTEGER)
		do
			if attached {like target_string} a_target as l_target then
				fill (l_target, pattern, a_adjustments)

			elseif attached {STRING_32} a_target as str_32 then
				fill (new_shared (str_32), pattern, a_adjustments)
			end
		end

	fill_general_by_string (a_target, pattern: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			if attached {like target_string} a_target as l_target then
				fill_by_string (l_target, pattern, a_adjustments)

			elseif attached {STRING_32} a_target as str_32 then
				fill_by_string (new_shared (str_32), pattern, a_adjustments)
			end
		end

feature {NONE} -- Implementation

	fill_intervals_by_string (a_target: IMMUTABLE_STRING_32; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			area_intervals.fill_by_string_32 (a_target, delimiter, a_adjustments)
			area := area_intervals.area
		end

	new_shared (a_target: STRING_32): IMMUTABLE_STRING_32
		do
			Result := Immutable_32.new_substring (a_target.area, 0, a_target.count)
		end

	shared_cursor: EL_STRING_32_ITERATION_CURSOR
		do
			Result := cursor_32 (target_string)
		end

	shared_target_substring (lower, upper: INTEGER): IMMUTABLE_STRING_32
		do
			Result := target_string.shared_substring (lower, upper)
		end

end