note
	description: "Zstring searcher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "12"

frozen class
	EL_ZSTRING_SEARCHER

inherit
	STRING_SEARCHER
		rename
			max_code_point_value as max_code_point_integer
		redefine
			internal_initialize_deltas
		end

	STRING_HANDLER

	EL_ZSTRING_CONSTANTS

	EL_ZCODE_CONVERSION

create
	make

feature -- Search

	fuzzy_index (a_string: like String_type; a_pattern: READABLE_STRING_GENERAL; start_pos, end_pos, fuzzy: INTEGER): INTEGER
			-- Position of first occurrence of `a_pattern' at or after `start_pos' in
			-- `a_string' with 0..`fuzzy' mismatches between `a_string' and `a_pattern'.
			-- 0 if there are no fuzzy matches.
		local
			i, j, l_min_offset, l_end_pos, l_area_lower, l_pattern_count, l_nb_mismatched: INTEGER
			l_matched: BOOLEAN; l_deltas_array: like deltas_array
			l_area: SPECIAL [CHARACTER]; l_char_code: NATURAL
			unencoded: EL_UNENCODED_CHARACTERS_INDEX
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
						from
							unencoded := a_string.unencoded_indexable
							l_pattern_count := a_pattern.count
							l_area := a_string.area
							l_area_lower := a_string.area_lower
							i := start_pos + l_area_lower
							l_end_pos := end_pos + 1 + l_area_lower
						until
							i + l_pattern_count > l_end_pos
						loop
							from
								j := 0
								l_nb_mismatched := 0
								l_matched := True
							until
								j = l_pattern_count
							loop
								l_char_code := area_z_code (l_area, unencoded, i + j - 1)
								if l_char_code /= a_pattern.code (j + 1) then
									l_nb_mismatched := l_nb_mismatched + 1;
									if l_nb_mismatched > fuzzy then
											-- Too many mismatched, so we stop
										j := l_pattern_count - 1	-- Jump out of loop
										l_matched := False
									end
								end
								j := j + 1
							end

							if l_matched then
									-- We got the substring
								Result := i - l_area_lower
								i := l_end_pos	-- Jump out of loop
							else
								if i + l_pattern_count <= end_pos then
										-- Pattern was not found, compute shift to next location
									from
										j := 0
										l_min_offset := l_pattern_count + 1
									until
										j > fuzzy
									loop
										l_char_code := area_z_code (l_area, unencoded, i + l_pattern_count - j - 1)
										if l_char_code > Max_code_point_value then
												-- No optimization for a characters above
												-- `Max_code_point_value'.
											l_min_offset := 1
											j := fuzzy + 1 -- Jump out of loop
										else
											l_min_offset := l_min_offset.min (l_deltas_array.item (j).item (l_char_code.to_integer_32))
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

	substring_index_with_deltas (
		a_string: like String_type; a_pattern: READABLE_STRING_GENERAL; start_pos, end_pos: INTEGER
	): INTEGER
			-- Position of first occurrence of `a_pattern' at or after `start_pos' in `a_string'.
			-- 0 if there are no matches.
		local
			i, j, l_end_pos, l_pattern_count, l_area_lower: INTEGER; l_char_code: NATURAL
			l_matched: BOOLEAN; l_deltas: like deltas; l_area: SPECIAL [CHARACTER]
			unencoded: EL_UNENCODED_CHARACTERS_INDEX
		do
			if a_string = a_pattern then
				if start_pos = 1 then
					Result := 1
				end
			else
				l_pattern_count := a_pattern.count
				check l_pattern_count_positive: l_pattern_count > 0 end
				unencoded := a_string.unencoded_indexable
				from
					l_area := a_string.area
					l_area_lower := a_string.area_lower
					i := start_pos + l_area_lower
					l_deltas := deltas
					l_end_pos := end_pos + 1 + l_area_lower
				until
					i + l_pattern_count > l_end_pos
				loop
					from
						j := 0
						l_matched := True
					until
						j = l_pattern_count
					loop
						l_char_code := area_z_code (l_area, unencoded, i + j - 1)
						if l_char_code /= a_pattern.code (j + 1) then
								-- Mismatch, so we stop
							j := l_pattern_count - 1	-- Jump out of loop
							l_matched := False
						end
						j := j + 1
					end

					if l_matched then
							-- We got the substring
						Result := i - l_area_lower
						i := l_end_pos	-- Jump out of loop
					else
							-- Pattern was not found, shift to next location
						if i + l_pattern_count <= end_pos then
							l_char_code := area_z_code (l_area, unencoded, i + l_pattern_count - 1)
							if l_char_code > Max_code_point_value then
									-- Character is too big, we revert to a slow comparison
								i := i + 1
							else
								i := i + l_deltas.item (l_char_code.to_integer_32)
							end
						else
							i := i + 1
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	internal_initialize_deltas (a_pattern: READABLE_STRING_GENERAL; a_pattern_count: INTEGER; a_deltas: like deltas)
			-- Initialize `a_deltas' with `a_pattern'.
			-- Optimized for the top `max_code_point_value' characters only.
		local
			i: INTEGER; l_char_code: NATURAL
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
				l_char_code := a_pattern.code (i + 1)
				if l_char_code <= max_code_point_value then
					a_deltas.put (a_pattern_count - i, l_char_code.to_integer_32)
				end
				i := i + 1
			end
		end

feature {NONE} -- Constants

	String_type: EL_READABLE_ZSTRING
		require else
			never_called: False
		once
			Result := Empty_string
		end

	Max_code_point_value: NATURAL = 2_000
		-- We optimize the search for the first 2000 code points of Unicode (i.e. using 8KB of memory).

		-- We need the NATURAL value because of the z_code `Sign_bit', which means we cannot
		-- compare with an integer. This conditional will not branch correctly:

		--    if l_char_code <= max_code_point_integer then

	Max_code_point_integer: INTEGER = 2000
		-- We optimize the search for the first 2000 code points of Unicode (i.e. using 8KB of memory).

		-- Ideally we want this to be type NATURAL but we are stuck with how it's defined in STRING_SEARCHER

end