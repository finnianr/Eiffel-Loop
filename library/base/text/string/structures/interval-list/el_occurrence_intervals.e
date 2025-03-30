note
	description: "[
		List of all occurrence intervals of a pattern or character in a string conforming to
		${READABLE_STRING_GENERAL}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 13:50:47 GMT (Sunday 30th March 2025)"
	revision: "36"

class
	EL_OCCURRENCE_INTERVALS

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			make as make_sized,
			fill as fill_from
		redefine
			make_empty
		end

	EL_SIDE_ROUTINES
		rename
			valid_sides as valid_adjustments
		export
			{ANY} valid_adjustments
		end

	EL_STRING_GENERAL_ROUTINES_I

	EL_STRING_8_CONSTANTS; EL_STRING_32_CONSTANTS; EL_ZSTRING_CONSTANTS

	EL_SHARED_ZSTRING_CODEC; EL_SHARED_UNICODE_PROPERTY

create
	make, make_empty, make_by_string, make_sized

feature {NONE} -- Initialization

	make (target: READABLE_STRING_GENERAL; delimiter: CHARACTER_32)
		do
			make_empty
			fill (target, delimiter, 0)
		end

	make_by_string (target, pattern: READABLE_STRING_GENERAL)
			-- Move to first position if any.
		do
			make_empty
			fill_by_string_general (target, pattern, 0)
		end

	make_empty
		do
			make_from_special (Default_area)
		end

feature -- Element change

	fill (target: READABLE_STRING_GENERAL; delimiter: CHARACTER_32; adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (adjustments)
		do
			fill_intervals (target, Empty_string_8, String_8_searcher, delimiter, adjustments)
		end

	fill_by_string_32 (target: READABLE_STRING_32; pattern: READABLE_STRING_GENERAL; adjustments: INTEGER)
		local
			l_pattern: READABLE_STRING_GENERAL
		do
			inspect pattern.count
				when 1 then
					fill (target, pattern [1], adjustments)
			else
				if is_zstring (target) and then attached {EL_READABLE_ZSTRING} target as z_target then
					fill_by_string (z_target, pattern, adjustments)

				elseif attached String_32_searcher as searcher then
					if is_zstring (pattern) then
						l_pattern := pattern.to_string_32
					else
						l_pattern := pattern
					end
					searcher.initialize_deltas (l_pattern)
					fill_intervals (target, l_pattern, searcher, '%U', adjustments)
				end
			end
		end

	fill_by_string_8 (target: READABLE_STRING_8; pattern: READABLE_STRING_GENERAL; adjustments: INTEGER)
		require
			valid_pattern: pattern.is_valid_as_string_8
		local
			l_pattern: READABLE_STRING_GENERAL
		do
			inspect pattern.count
				when 1 then
					fill (target, pattern [1], adjustments)
			else
				if attached String_8_searcher as searcher then
					if pattern.is_string_8 then
						l_pattern := pattern
					else
						l_pattern := pattern.to_string_8
					end
					searcher.initialize_deltas (l_pattern)
					fill_intervals (target, l_pattern, searcher, '%U', adjustments)
				end
			end
		end

	fill_by_string_general (target, pattern: READABLE_STRING_GENERAL; adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (adjustments)
		do
			if target.is_string_8 and then attached {READABLE_STRING_8} target as str_8 then
				fill_by_string_8 (str_8, pattern, adjustments)

			elseif is_zstring (target) and then attached {EL_READABLE_ZSTRING} target as z_target then
				fill_by_string (z_target, pattern, adjustments)

			elseif attached {READABLE_STRING_32} target as str_32 then
				fill_by_string_32 (str_32, pattern, adjustments)
			end
		end

	fill_by_string (target: EL_READABLE_ZSTRING; pattern: READABLE_STRING_GENERAL; adjustments: INTEGER)
		do
			inspect pattern.count
				when 1 then
					fill (target, pattern [1], adjustments)
			else
				if pattern.is_string_8 and then attached target.compatible_string_8 (pattern) as str_8 then
					if target.has_mixed_encoding then
						String_searcher.initialize_deltas (str_8)
						fill_intervals (target, str_8, String_searcher, '%U', adjustments)
					else
						String_8_searcher.initialize_deltas (str_8)
						fill_intervals (target.to_shared_immutable_8, str_8, String_8_searcher, '%U', adjustments)
					end

				elseif attached target.shared_z_code_pattern_general (pattern, 1) as z_code_pattern then
					String_searcher.initialize_deltas (z_code_pattern)
					fill_intervals (target, z_code_pattern, String_searcher, '%U', adjustments)
				end
			end
		end

feature {NONE} -- Implementation

	extend_buffer (
		target: READABLE_STRING_GENERAL
		l_area: like Intervals_buffer; search_index, pattern_count, adjustments: INTEGER
		final: BOOLEAN
	)
		do
			if not final then
				l_area.extend (search_index, search_index + pattern_count - 1)
			end
		end

	fill_intervals (
		target, pattern: READABLE_STRING_GENERAL; searcher: STRING_SEARCHER
		uc: CHARACTER_32; adjustments: INTEGER
	)
		require
			valid_search_string: pattern.count /= 1
		local
			i, string_count, pattern_count, search_index, search_type: INTEGER
			l_area: like Intervals_buffer; string_8_target: STRING_8
			c: CHARACTER; character_outside_range: BOOLEAN
		do
			l_area := Intervals_buffer
			l_area.wipe_out

			if target.count > 0 then
				string_count := target.count
				if pattern.is_empty then
					pattern_count := 1
					search_type := Index_of_character_32
				else
					pattern_count := pattern.count
				end
				if pattern_count = 1 and then target.is_string_8 then
					if attached {READABLE_STRING_8} target as str_8 then
						string_8_target := str_8
					end
					character_outside_range := not uc.is_character_8
					c := uc.to_character_8
					search_type := Index_of_character_8
				else
					string_8_target := Empty_string_8
				end
				if not character_outside_range then
					from i := 1 until i = 0 or else i > string_count - pattern_count + 1 loop
						inspect search_type
							when Index_of_character_8 then
								i := string_8_target.index_of (c, i)

							when Index_of_character_32 then
								i := target.index_of (uc, i)
						else
							i := searcher.substring_index_with_deltas (target, pattern, i, target.count)
						end
						if i > 0 then
							search_index := i
							extend_buffer (target, l_area, search_index, pattern_count, adjustments, False)
							i := i + pattern_count
						end
					end
				end
				extend_buffer (target, l_area, search_index, pattern_count, adjustments, True)
			end
			make_sized (l_area.count)
			area.copy_data (l_area.area, 0, 0, l_area.count * 2)
		end

feature {NONE} -- Constants

	Default_area: SPECIAL [INTEGER]
		once
			create Result.make_empty (0)
		end

	Index_of_character_32: INTEGER = 32

	Index_of_character_8: INTEGER = 8

	Intervals_buffer: EL_ARRAYED_INTERVAL_LIST
		once
			create Result.make (50)
		end

end