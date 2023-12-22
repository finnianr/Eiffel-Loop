note
	description: "[
		List of all occurrence intervals of a pattern or character in a string conforming to
		[$source READABLE_STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-22 10:58:19 GMT (Friday 22nd December 2023)"
	revision: "29"

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

	EL_STRING_8_CONSTANTS; EL_STRING_32_CONSTANTS; EL_ZSTRING_CONSTANTS

	EL_SHARED_CLASS_ID; EL_SHARED_ZSTRING_CODEC; EL_SHARED_UNICODE_PROPERTY

create
	make, make_empty, make_by_string, make_sized

feature {NONE} -- Initialization

	make (a_target: READABLE_STRING_GENERAL; delimiter: CHARACTER_32)
		do
			make_empty
			fill (a_target, delimiter, 0)
		end

	make_by_string (a_target, a_pattern: READABLE_STRING_GENERAL)
			-- Move to first position if any.
		do
			make_empty
			fill_by_string (a_target, a_pattern, 0)
		end

	make_empty
		do
			area_v2 := Default_area
		end

feature -- Element change

	fill (a_target: READABLE_STRING_GENERAL; delimiter: CHARACTER_32; adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (adjustments)
		do
			fill_intervals (a_target, Empty_string_8, String_8_searcher, delimiter, adjustments)
		end

	fill_by_string (a_target, a_pattern: READABLE_STRING_GENERAL; adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (adjustments)
		do
			if a_pattern.count = 1 then
				fill_intervals (a_target, Empty_string_8, String_8_searcher, a_pattern [1], adjustments)
			else
				inspect Class_id.character_bytes (a_target)
					when 'X' then
						if attached {EL_READABLE_ZSTRING} a_target as zstr
							and then attached zstr.z_code_pattern (a_pattern) as z_code_pattern
						then
							String_searcher.initialize_deltas (z_code_pattern)
							fill_intervals (a_target, z_code_pattern, String_searcher, '%U', adjustments)
						end
				else
					if attached shared_searcher (a_target) as searcher then
						searcher.initialize_deltas (a_pattern)
						fill_intervals (a_target, a_pattern, searcher, '%U', adjustments)
					end
				end
			end
		end

feature {NONE} -- Implementation

	extend_buffer (
		a_target: READABLE_STRING_GENERAL
		l_area: like Intervals_buffer; search_index, pattern_count, adjustments: INTEGER
		final: BOOLEAN
	)
		do
			if not final then
				l_area.extend (search_index, search_index + pattern_count - 1)
			end
		end

	fill_intervals (
		a_target, a_pattern: READABLE_STRING_GENERAL; searcher: STRING_SEARCHER
		uc: CHARACTER_32; adjustments: INTEGER
	)
		require
			valid_search_string: a_pattern.count /= 1
		local
			i, string_count, pattern_count, search_index, search_type: INTEGER
			l_area: like Intervals_buffer; string_8_target: STRING_8
			c: CHARACTER; character_outside_range: BOOLEAN
		do
			l_area := Intervals_buffer
			l_area.wipe_out

			if a_target.count > 0 then
				string_count := a_target.count
				if a_pattern.is_empty then
					pattern_count := 1
					search_type := Index_of_character_32
				else
					pattern_count := a_pattern.count
				end
				if pattern_count = 1 and then a_target.is_string_8 then
					if attached {READABLE_STRING_8} a_target as str_8 then
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
								i := a_target.index_of (uc, i)
						else
							i := searcher.substring_index_with_deltas (a_target, a_pattern, i, a_target.count)
						end
						if i > 0 then
							search_index := i
							extend_buffer (a_target, l_area, search_index, pattern_count, adjustments, False)
							i := i + pattern_count
						end
					end
				end
				extend_buffer (a_target, l_area, search_index, pattern_count, adjustments, True)
			end
			make_sized (l_area.count)
			area.copy_data (l_area.area, 0, 0, l_area.count * 2)
		end

	shared_searcher (a_target: READABLE_STRING_GENERAL): STRING_SEARCHER
		do
			if a_target.is_string_8 then
				Result := String_8_searcher
			else
				Result := String_32_searcher
			end
		end

feature {NONE} -- Constants

	Default_area: SPECIAL [INTEGER]
		once
			create Result.make_empty (0)
		end

	Intervals_buffer: EL_ARRAYED_INTERVAL_LIST
		once
			create Result.make (50)
		end

	Index_of_character_8: INTEGER = 8

	Index_of_character_32: INTEGER = 32

end