note
	description: "Searchable aspects of ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-06 11:55:31 GMT (Saturday 6th April 2024)"
	revision: "54"

deferred class
	EL_SEARCHABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

feature -- Index position

	index_of (uc: CHARACTER_32; start_index: INTEGER): INTEGER
		local
			c: CHARACTER
		do
			inspect uc.code
				when 0 .. Max_ascii_code then
					Result := internal_index_of (uc.to_character_8, start_index)
			else
				c := Codec.encoded_character (uc)
				inspect c
					when Substitute then
						Result := unencoded_index_of (uc, start_index, null)
				else
					Result := internal_index_of (c, start_index)
				end
			end
		ensure then
			valid_result: Result = 0 or (start_index <= Result and Result <= count)
			zero_if_absent: (Result = 0) = not substring (start_index, count).has (uc)
			found_if_present: substring (start_index, count).has (uc) implies item (Result) = uc
			none_before: substring (start_index, count).has (uc) implies
				not substring (start_index, Result - 1).has (uc)
		end

	index_of_z_code (a_z_code: NATURAL; start_index: INTEGER): INTEGER
		do
			if a_z_code > 0xFF then
				Result := unencoded_index_of (z_code_to_unicode (a_z_code).to_character_32, start_index, null)
			else
				Result := internal_index_of (a_z_code.to_character_8, start_index)
			end
		ensure then
			valid_result: Result = 0 or (start_index <= Result and Result <= count)
			zero_if_absent: (Result = 0) = not substring (start_index, count).has_z_code (a_z_code)
			found_if_present: substring (start_index, count).has_z_code (a_z_code) implies z_code (Result) = a_z_code
			none_before: substring (start_index, count).has_z_code (a_z_code) implies
				not substring (start_index, Result - 1).has_z_code (a_z_code)
		end

	last_index_of (uc: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
			-- Position of last occurrence of `c',
			-- 0 if none.
		local
			c: CHARACTER
		do
			inspect uc.code
				when 0 .. Max_ascii_code then
					Result := internal_last_index_of (uc.to_character_8, start_index_from_end)
			else
				c := Codec.encoded_character (uc)
				inspect c
					when Substitute then
						Result := unencoded_last_index_of (uc, start_index_from_end)
				else
					Result := internal_last_index_of (c, start_index_from_end)
				end
			end
		end

	substring_index (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		local
			r: EL_READABLE_STRING_GENERAL_ROUTINES; return_default: BOOLEAN; type_code: CHARACTER
		do
			type_code := Class_id.character_bytes (other)
			inspect other.count
				when 1 then
				-- character search
					inspect type_code
						when 'X' then
							if attached {EL_READABLE_ZSTRING} other as z_str then
								Result := index_of_z_code (z_str.z_code (1), start_index)
							end
					else
						Result := index_of (other [1], start_index)
					end
			else
			-- string search
				inspect type_code
					when '1' then
						if attached r.to_ascii_string_8 (other) as ascii_str then
							Result := String_8.substring_index_ascii (Current, ascii_str, start_index)
						else
							return_default := True
						end
					when 'X' then
						if attached {EL_READABLE_ZSTRING} other as z_str then
							Result := substring_index_zstring (z_str, start_index)
						end
				else
					return_default := True
				end
				if return_default
					and then attached shared_z_code_pattern_general (other, 1) as z_code_string
					and then attached String_searcher as searcher
				then
					searcher.initialize_deltas (z_code_string)
					Result := searcher.substring_index_with_deltas (current_readable, z_code_string, start_index, count)
				end
			end
		end

	substring_index_in_bounds (other: READABLE_STRING_GENERAL; start_pos, end_pos: INTEGER): INTEGER
		local
			r: EL_READABLE_STRING_GENERAL_ROUTINES; return_default: BOOLEAN
		do
			inspect Class_id.character_bytes (other)
				when '1' then
					if attached r.to_ascii_string_8 (other) as ascii_str then
						Result := String_8.substring_index_in_bounds_ascii (Current, ascii_str, start_pos, end_pos)
					else
						return_default := True
					end
				when '4' then
					return_default := True
				when 'X' then
					if attached {EL_READABLE_ZSTRING} other as z_other then
						Result := substring_index_in_bounds_zstring (z_other, start_pos, end_pos)
					end
			end
			if return_default
				and then attached shared_z_code_pattern_general (other, 1) as z_code_string
				and then attached String_searcher as searcher
			then
				searcher.initialize_deltas (z_code_string)
				Result := searcher.substring_index_with_deltas (current_readable, z_code_string, start_pos, end_pos)
			end
		end

	substring_right_index (other: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		-- index to right of first occurrence of `other' if valid index or else 0
		do
			Result := substring_index (other, start_index)
			if Result > 0 then
				Result := Result + other.count
			end
		end

	substring_right_index_general (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		do
			Result := substring_index (other, start_index)
			if Result > 0 then
				Result := Result + other.count
			end
		end

	word_index (word: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		local
			has_left_boundary, has_right_boundary, found: BOOLEAN
			index: INTEGER
		do
			from index := start_index; Result := 1 until Result = 0 or else found or else index + word.count - 1 > count loop
				Result := substring_index (word, index)
				if Result > 0 then
					has_left_boundary := Result = 1 or else not is_alpha_numeric_item (Result - 1)
					has_right_boundary := Result + word.count - 1 = count or else not is_alpha_numeric_item (Result + word.count)
					if has_left_boundary and has_right_boundary then
						found := True
					else
						index := Result + 1
					end
				end
			end
		end

feature -- Occurrence index lists

	substring_index_list (delimiter: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): like internal_substring_index_list
		do
			Result := internal_substring_index_list (adapted_argument_general (delimiter, 1))
			if keep_ref then
				Result := Result.twin
			end
		end

	substitution_marker_index_list: ARRAYED_LIST [INTEGER]
		-- shared list of indices of unescaped template substitution markers '%S' AKA '#'
		local
			i, i_upper: INTEGER; c_i: CHARACTER
		do
			Result := Once_substring_indices.emptied
			i_upper := count - 1
			if attached area as l_area then
				from i := 0 until i > i_upper loop
					c_i := l_area [i]
					inspect c_i
						when '%S' then
							Result.extend (i + 1)
					else
					end
					i := i + 1
				end
			end
		end

	substring_intervals (str: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): EL_OCCURRENCE_INTERVALS
		do
			Result := internal_substring_intervals (str)
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- Basic operations

	fill_alpha_numeric_intervals (interval_list: EL_ARRAYED_INTERVAL_LIST)
		-- fill `interval_list' with substring intervals of contiguous alpha-numeric characters
		local
			i, j, block_index, i_upper, l_count: INTEGER; c_i: CHARACTER
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION; interval: NATURAL_64
		do
			if attached area as l_area and then attached unencoded_area as area_32
				and then attached Codec as l_codec
			then
				interval_list.wipe_out
				i_upper := area_upper
				from i := 0 until i > i_upper loop
					c_i := l_area [i]
					inspect c_i
						when Substitute then
							if attached iter.block_string (block_index, area_32) as str_32 then
								block_index := iter.next_index (block_index, str_32)
								l_count := str_32.count
								from j := 1 until j > l_count loop
									if str_32 [j].is_alpha_numeric then
										interval := interval_list.extend_next_upper (interval, i + j)
									end
									j := j + 1
								end
								i := i + l_count
							end
						when Control_0 .. Control_25, Control_27 .. Max_ascii then
							if c_i.is_alpha_numeric then
								interval := interval_list.extend_next_upper (interval, i + 1)
							end
							i := i + 1
					else
						if l_codec.is_alphanumeric (c_i.natural_32_code) then
							interval := interval_list.extend_next_upper (interval, i + 1)
						end
						i := i + 1
					end
				end
				interval_list.extend_compact (interval)
			end
		end

	fill_index_list (list: ARRAYED_LIST [INTEGER]; a_pattern: READABLE_STRING_GENERAL)
		-- fill `list' with all indices of `a_pattern' found in `Current'
		local
			index, l_count, pattern_count: INTEGER; r: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			pattern_count := a_pattern.count; l_count := count

			if attached r.to_ascii_string_8 (a_pattern) as ascii_str then
				String_8.fill_index_list (list, Current, ascii_str)

			elseif attached shared_z_code_pattern_general (a_pattern, 1) as z_code_string
				and then attached string_searcher as searcher
			then
				searcher.initialize_deltas (z_code_string)
				from index := 1 until index = 0 or else index > l_count - pattern_count + 1 loop
					index := searcher.substring_index_with_deltas (current_readable, z_code_string, index, l_count)
					if index > 0 then
						list.extend (index)
						index := index + pattern_count
					end
				end
			end
		end

	fill_index_list_by_character (list: ARRAYED_LIST [INTEGER]; uc: CHARACTER_32)
		do
			fill_index_list_by_z_code (list, Codec.as_z_code (uc))
		end

feature {EL_SHARED_ZSTRING_CODEC} -- Implementation

	z_code_pattern (a_pattern: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		local
			r: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			if attached r.to_ascii_string_8 (a_pattern) as ascii_pattern then
				Result := ascii_pattern
			else
				Result := shared_z_code_pattern_general (a_pattern, 1)
			end
		end

	shared_z_code_pattern (index: INTEGER): STRING_32
			-- Current expanded as `z_code' sequence
		require
			valid_index: 1 <= index and index <= 2
		do
			Result := Z_code_pattern_array [index - 1]
			fill_with_z_code (Result)
		end

	shared_z_code_pattern_general (general: READABLE_STRING_GENERAL; index: INTEGER): STRING_32
		local
			r: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			Result := Z_code_pattern_array [index - 1]
			r.shared_cursor (general).fill_z_codes (Result)
		end

feature {NONE} -- Implementation

	empty_occurrence_intervals (i: INTEGER): EL_OCCURRENCE_INTERVALS
		do
			Result := Occurrence_intervals [i]
			Result.wipe_out
		end

	fill_index_list_by_z_code (list: ARRAYED_LIST [INTEGER]; a_z_code: NATURAL)
		-- fill `list' with all indices of `a_z_code' found in `Current'
		local
			i, l_count, index, block_index: INTEGER
			l_area: like area; uc: CHARACTER_32; c: CHARACTER
		do
			if a_z_code > 0xFF then
				uc := z_code_to_unicode (a_z_code).to_character_32
				from index := 1 until index = 0 loop
					index := unencoded_index_of (uc, index, $block_index)
					if index > 0 then
						list.extend (index)
						index := index + 1
					end
				end
			else
				c := a_z_code.to_character_8
				l_area := area; l_count := count
				from i := 0 until i = l_count loop
					if l_area [i] = c then
						list.extend (i + 1)
					end
					i := i + 1
				end
			end
		end

	internal_substring_index_list (str: READABLE_STRING_GENERAL): ARRAYED_LIST [INTEGER]
		-- shared list of indices of `str' occurring in `Current'
		local
			str_count: INTEGER
		do
			str_count := str.count
			Result := Once_substring_indices.emptied

			if (attached {EL_SEARCHABLE_ZSTRING} str as zstr and then zstr = Current)
				or else str_count = 0
			then
				Result.extend (1)

			elseif str_count <= count then
				if attached {EL_READABLE_ZSTRING} str as z_str then
					inspect respective_encoding (z_str)
						when Both_have_mixed_encoding then
							if str_count = 1 then
								fill_index_list_by_z_code (Result, z_str.z_code (1))
							else
								fill_index_list (Result, z_str)
							end

						when Only_other then
							-- cannot find `z_str'
							do_nothing

						when Only_current, Neither then
							String_8.fill_index_list (Result, Current, String_8.injected (z_str, 1))

					else
					end
				elseif str_count = 1 then
					fill_index_list_by_character (Result, str [1])
				else
					fill_index_list (Result, str)
				end
			end
		end

	internal_substring_intervals (str: READABLE_STRING_GENERAL): EL_OCCURRENCE_INTERVALS
		do
			Result := Occurrence_intervals [0]
			Result.wipe_out
			Result.fill_by_string (current_readable, str, 0)
		end

	substring_index_in_bounds_zstring (other: EL_READABLE_ZSTRING; start_pos, end_pos: INTEGER): INTEGER
		local
			has_mixed_in_range: BOOLEAN
		do
			has_mixed_in_range := has_unencoded_between_optimal (area, start_pos, end_pos)

			inspect current_other_bitmap (has_mixed_in_range, other.has_mixed_encoding)
				when Both_have_mixed_encoding then
					-- Make calls to `code' more efficient by caching calls to `unencoded_code' in expanded string
					Result := String_searcher.substring_index (current_readable, other.shared_z_code_pattern (1), start_pos, end_pos)
				when Only_current, Neither then
					Result := String_8.substring_index_in_bounds (Current, other, start_pos, end_pos)
				when Only_other then
					Result := 0
			else
			end
		end

	substring_index_zstring (other: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		local
			has_mixed_in_range: BOOLEAN
		do
			has_mixed_in_range := has_unencoded_between_optimal (area, start_index, count)
			inspect current_other_bitmap (has_mixed_in_range, other.has_mixed_encoding)
				when Only_current, Neither then
					Result := String_8.substring_index (Current, other, start_index)

				when Both_have_mixed_encoding then
					-- Make calls to `code' more efficient by caching calls to `unencoded_code' in expanded string
					Result := String_searcher.substring_index (current_readable, other.shared_z_code_pattern (1), start_index, count)

				when Only_other then
					Result := 0
			else
			end
		end

	is_reversible_z_code_pattern (general: READABLE_STRING_GENERAL; z_code_string: STRING_32): BOOLEAN
		local
			zstr, zstr_2: ZSTRING
		do
			create zstr.make_from_general (general)
			create zstr_2.make (z_code_string.count)
			across z_code_string as l_code loop
				zstr_2.append_z_code (l_code.item.natural_32_code)
			end
			Result := zstr ~ zstr_2
		end

feature {NONE} -- Constants

	Occurrence_intervals: SPECIAL [EL_OCCURRENCE_INTERVALS]
		once
			create Result.make_filled (create {EL_OCCURRENCE_INTERVALS}.make_empty, 2)
			Result [1] := create {EL_OCCURRENCE_INTERVALS}.make_empty
		end

	String_searcher: EL_ZSTRING_SEARCHER
		once
			create Result.make
		end

	Z_code_pattern_array: SPECIAL [STRING_32]
		once
			create Result.make_filled (create {STRING_32}.make_empty, 2)
			Result [1] := create {STRING_32}.make_empty
		end

end