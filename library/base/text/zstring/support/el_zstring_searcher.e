note
	description: "Searcher for ${ZSTRING} strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 7:54:38 GMT (Tuesday 15th April 2025)"
	revision: "20"

frozen class
	EL_ZSTRING_SEARCHER

inherit
	STRING_SEARCHER
		rename
			max_code_point_value as max_code_point_integer
		redefine
			internal_initialize_deltas, make
		end

	EL_STRING_HANDLER

	EL_ZCODE_CONVERSION

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		require else
			not_using_shared_extended_strings: not attached {EL_STRING_GENERAL_ROUTINES_I} Current
		do
			Precursor
			create Z_code_pattern.make_empty
			create super_readable_32.make_empty
			create super_readable_8.make_empty
		end

feature -- Initialization

	initialize_z_code_deltas (pattern: READABLE_STRING_GENERAL)
		do
			initialize_z_code_deltas_for_type (pattern, string_storage_type (pattern))
		end

	initialize_z_code_deltas_for_type (pattern: READABLE_STRING_GENERAL; type_code: CHARACTER)
		local
			extended_string: detachable EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		do
			inspect type_code
				when '1' then
					extended_string := super_readable_8

				when '4' then
					extended_string := super_readable_32
			else
				if attached {ZSTRING} pattern as z_str then
					z_str.fill_z_codes (z_code_pattern)
				end
			end
			if extended_string /= void and then attached extended_string as extended then
				extended.set_target (pattern)
				extended.fill_z_codes (z_code_pattern)
			end
			initialize_deltas (z_code_pattern)
		end

feature -- Search

	fuzzy_index (a_string: like String_type; a_pattern: READABLE_STRING_GENERAL; start_pos, end_pos, fuzzy: INTEGER): INTEGER
			-- Position of first occurrence of `a_pattern' at or after `start_pos' in
			-- `a_string' with 0..`fuzzy' mismatches between `a_string' and `a_pattern'.
			-- 0 if there are no fuzzy matches.
		local
			i, j, l_min_offset, end_index, l_area_lower, pattern_count, l_nb_mismatched, block_index: INTEGER
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION; area_32: like String_type.unencoded_area
			l_matched: BOOLEAN; l_deltas_array: like deltas_array
			l_area: SPECIAL [CHARACTER]; char_code: NATURAL
		do
			if fuzzy = a_pattern.count then
					-- More mismatches than the pattern length.
				Result := start_pos
			else
				if fuzzy = 0 then
					Result := substring_index (a_string, a_pattern, start_pos, end_pos)
				else
					initialize_fuzzy_deltas (a_pattern, fuzzy)
					l_deltas_array := deltas_array
					if l_deltas_array /= Void then
						l_area := a_string.area; area_32 := a_string.unencoded_area
						from
							pattern_count := a_pattern.count
							l_area_lower := a_string.area_lower
							i := start_pos + l_area_lower
							end_index := end_pos + 1 + l_area_lower
						until
							i + pattern_count > end_index
						loop
							from
								j := 0
								l_nb_mismatched := 0
								l_matched := True
							until
								j = pattern_count
							loop
								char_code := iter.i_th_z_code ($block_index, l_area, area_32, i + j - 1)
								if char_code /= a_pattern.code (j + 1) then
									l_nb_mismatched := l_nb_mismatched + 1;
									if l_nb_mismatched > fuzzy then
											-- Too many mismatched, so we stop
										j := pattern_count - 1	-- Jump out of loop
										l_matched := False
									end
								end
								j := j + 1
							end

							if l_matched then
									-- We got the substring
								Result := i - l_area_lower
								i := end_index	-- Jump out of loop
							else
								if i + pattern_count <= end_pos then
										-- Pattern was not found, compute shift to next location
									from
										j := 0
										l_min_offset := pattern_count + 1
									until
										j > fuzzy
									loop
										char_code := iter.i_th_z_code ($block_index, l_area, area_32, i + pattern_count - j - 1)
										if char_code > Max_code_point_value then
												-- No optimization for a characters above
												-- `Max_code_point_value'.
											l_min_offset := 1
											j := fuzzy + 1 -- Jump out of loop
										else
											l_min_offset := l_min_offset.min (l_deltas_array.item (j).item (char_code.to_integer_32))
										end
										j := j + 1
									end
									i := i + l_min_offset
								else
									i := i + 1
								end
							end
						end
					end
					deltas_array := Void
				end
			end
		end

	sub_zstring_index (a_string: like string_type; a_pattern: EL_READABLE_ZSTRING; start_pos, end_pos: INTEGER): INTEGER
		do
			a_pattern.fill_z_codes (z_code_pattern)
			Result := substring_index (a_string, z_code_pattern, start_pos, end_pos)
		end

	substring_index_with_deltas (
		a_string: like String_type; a_pattern: READABLE_STRING_GENERAL; start_pos, end_pos: INTEGER
	): INTEGER
		-- Position of first occurrence of `a_pattern' at or after `start_pos' in `a_string'.
		-- 0 if there are no matches.
		local
			i, j, end_index, pattern_count, l_area_lower, block_index: INTEGER; char_code: NATURAL
			l_matched: BOOLEAN; l_deltas: like deltas; l_area: SPECIAL [CHARACTER]
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION; area_32: like String_type.unencoded_area
		do
			if a_string = a_pattern then
				if start_pos = 1 then
					Result := 1
				end
			else
				pattern_count := a_pattern.count
				check l_pattern_count_positive: pattern_count > 0 end
				l_area := a_string.area; area_32 := a_string.unencoded_area
				from
					l_area_lower := a_string.area_lower
					i := start_pos + l_area_lower
					l_deltas := deltas
					end_index := end_pos + 1 + l_area_lower
				until
					i + pattern_count > end_index
				loop
					from
						j := 0
						l_matched := True
					until
						j = pattern_count
					loop
						char_code := iter.i_th_z_code ($block_index, l_area, area_32, i + j - 1)
						if char_code /= a_pattern.code (j + 1) then
						-- Mismatch, so we stop
							j := pattern_count - 1 -- Jump out of loop
							l_matched := False
						end
						j := j + 1
					end

					if l_matched then
					-- We got the substring
						Result := i - l_area_lower
						i := end_index	-- Jump out of loop
					else
					-- Pattern was not found, shift to next location
						if i + pattern_count <= end_pos then
							char_code := iter.i_th_z_code ($block_index, l_area, area_32, i + pattern_count - 1)
							if char_code > Max_code_point_value then
									-- Character is too big, we revert to a slow comparison
								i := i + 1
							else
								i := i + l_deltas.item (char_code.to_integer_32)
							end
						else
							i := i + 1
						end
					end
				end
			end
		end

	substring_index_with_z_code_pattern (a_string: like String_type; start_pos, end_pos: INTEGER): INTEGER
		-- substring index with pattern previously initialized by `initialize_z_code_deltas'
		do
			Result := substring_index_with_deltas (a_string, z_code_pattern, start_pos, end_pos)
		end

feature {NONE} -- Implementation

	internal_initialize_deltas (a_pattern: READABLE_STRING_GENERAL; a_pattern_count: INTEGER; a_deltas: like deltas)
			-- Initialize `a_deltas' with `a_pattern'.
			-- Optimized for the top `max_code_point_value' characters only.
		local
			i: INTEGER; char_code: NATURAL
		do
				-- Initialize the delta table (one more than pattern count).
			a_deltas.fill_with (a_pattern_count + 1, 0, Max_code_point_integer)

				-- Now for each character within the pattern, fill in shifting necessary
				-- to bring the pattern to the character. The rightmost value is kept, as
				-- we scan the pattern from left to right (ie. if there is two 'a', only the
				-- delta associated with the second --rightmost-- will be kept).
			from
				i := 0
			until
				i = a_pattern_count
			loop
				char_code := a_pattern.code (i + 1)
				if char_code <= max_code_point_value then
					a_deltas.put (a_pattern_count - i, char_code.to_integer_32)
				end
				i := i + 1
			end
		end

feature {STRING_HANDLER} -- Internal attributes

	z_code_pattern: STRING_32

	super_readable_32: EL_READABLE_STRING_32

	super_readable_8: EL_READABLE_STRING_8

feature {NONE} -- Constants

	Max_code_point_integer: INTEGER = 2000
		-- We optimize the search for the first 2000 code points of Unicode (i.e. using 8KB of memory).

		-- Ideally we want this to be type NATURAL but we are stuck with how it's defined in STRING_SEARCHER

	Max_code_point_value: NATURAL = 2_000
		-- We optimize the search for the first 2000 code points of Unicode (i.e. using 8KB of memory).

		-- We need the NATURAL value because of the z_code `Sign_bit', which means we cannot
		-- compare with an integer. This conditional will not branch correctly:

		--    if char_code <= max_code_point_integer then

	String_type: EL_READABLE_ZSTRING
		require else
			never_called: False
		once
			Result := Empty_string
		end

end