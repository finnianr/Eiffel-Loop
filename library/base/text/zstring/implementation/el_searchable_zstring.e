note
	description: "Searchable aspects of [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-21 12:14:31 GMT (Tuesday 21st February 2023)"
	revision: "25"

deferred class
	EL_SEARCHABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_READABLE_ZSTRING_I

feature -- Index position

	index_of (uc: CHARACTER_32; start_index: INTEGER): INTEGER
		local
			c: CHARACTER
		do
			if uc.code <= Max_7_bit_code then
				Result := internal_index_of (uc.to_character_8, start_index)
			else
				c := Codec.encoded_character (uc)
				if c = Substitute then
					Result := unencoded_index_of (uc, start_index)
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
			if a_z_code <= 0xFF then
				Result := internal_index_of (a_z_code.to_character_8, start_index)
			else
				Result := unencoded_index_of (z_code_to_unicode (a_z_code).to_character_32, start_index)
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
			if uc.code <= Max_7_bit_code then
				Result := internal_last_index_of (uc.to_character_8, start_index_from_end)
			else
				c := Codec.encoded_character (uc)
				if c = Substitute then
					Result := unencoded_last_index_of (uc, start_index_from_end)
				else
					Result := internal_last_index_of (c, start_index_from_end)
				end
			end
		end

	substring_index (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		do
			if attached {EL_READABLE_ZSTRING} other as z_str then
				if z_str.count = 1 then
					Result := index_of_z_code (z_str.z_code (1), start_index)
				else
					Result := substring_index_zstring (z_str, start_index)
				end

			elseif other.count = 1 then
				Result := index_of (other [1], start_index)

			elseif attached shared_search_pattern (other) as pattern then
				if attached {READABLE_STRING_8} pattern as str_8 then
					Result := String_8.substring_index_ascii (Current, str_8, start_index)

				elseif attached String_searcher as searcher then
					searcher.initialize_deltas (pattern)
					Result := searcher.substring_index_with_deltas (current_readable, pattern, start_index, count)
				end
			end
		end

	substring_index_in_bounds (other: EL_READABLE_ZSTRING; start_pos, end_pos: INTEGER): INTEGER
		local
			has_mixed_in_range: BOOLEAN
		do
			has_mixed_in_range := has_unencoded_between_optimal (area, start_pos, end_pos)

			inspect current_other_bitmap (has_mixed_in_range, other.has_mixed_encoding)
				when Both_have_mixed_encoding then
					-- Make calls to `code' more efficient by caching calls to `unencoded_code' in expanded string
					Result := String_searcher.substring_index (current_readable, other.as_expanded (1), start_pos, end_pos)
				when Only_current, Neither then
					Result := String_8.substring_index_in_bounds (Current, other, start_pos, end_pos)
				when Only_other then
					Result := 0
			else
			end
		end

	substring_index_in_bounds_general (other: READABLE_STRING_GENERAL; start_pos, end_pos: INTEGER): INTEGER
		do
			Result := substring_index_in_bounds (adapted_argument (other, 1), start_pos, end_pos)
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

	word_index (word: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
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

	word_index_general (word: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		do
			Result := word_index (adapted_argument (word, 1), start_index)
		end

feature -- Occurrence index lists

	substring_index_list (delimiter: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): like internal_substring_index_list
		do
			Result := internal_substring_index_list (adapted_argument (delimiter, 1))
			if keep_ref then
				Result := Result.twin
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

	fill_index_list (list: ARRAYED_LIST [INTEGER]; a_pattern: READABLE_STRING_GENERAL)
		-- fill `list' with all indices of `a_pattern' found in `Current'
		local
			pattern: READABLE_STRING_GENERAL; index, l_count, pattern_count: INTEGER
		do
			pattern_count := a_pattern.count; l_count := count
			pattern := shared_search_pattern (a_pattern)

			if attached {READABLE_STRING_8} pattern as ascii_pattern then
				String_8.fill_index_list (list, Current, ascii_pattern)

			elseif attached string_searcher as searcher then
				searcher.initialize_deltas (pattern)
				from index := 1 until index = 0 or else index > l_count - pattern_count + 1 loop
					index := searcher.substring_index_with_deltas (current_readable, pattern, index, l_count)
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

feature {NONE} -- Implementation

	empty_occurrence_intervals (i: INTEGER): EL_OCCURRENCE_INTERVALS
		do
			Result := Occurrence_intervals [i]
			Result.wipe_out
		end

	fill_index_list_by_z_code (list: ARRAYED_LIST [INTEGER]; a_z_code: NATURAL)
		-- fill `list' with all indices of `a_z_code' found in `Current'
		local
			unencoded: like unencoded_indexable; l_area: like area
			uc: CHARACTER_32; c: CHARACTER; i, l_count, index: INTEGER
		do
			if a_z_code > 0xFF then
				uc := z_code_to_unicode (a_z_code).to_character_32
				unencoded := unencoded_indexable
				from index := 1 until index = 0 loop
					index := unencoded.index_of (uc, index)
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
			Result := Once_substring_indices; Result.wipe_out
			if str = Current or else str_count = 0 then
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

	shared_expanded_32 (str_32: READABLE_STRING_32): STRING_32
		--	`str_32' expanded as z-code for `String_searcher'
		local
			area_32: like unencoded_area; l_codec: like codec
			i, i_final: INTEGER
		do
			if attached cursor_32 (str_32) as cursor then
				Result := Buffer_32.empty; l_codec := codec; area_32 := cursor.area
				i_final := cursor.area_first_index + str_32.count
				from i := cursor.area_first_index until i = i_final loop
					Result.extend (l_codec.as_z_code (area_32 [i]).to_character_32)
					i := i + 1
				end
			end
		ensure
			same_count: Result.count = str_32.count
		end

	shared_expanded_8 (cursor: EL_STRING_8_ITERATION_CURSOR): STRING_32
		--	`cursor.target' string expanded as z-code for `String_searcher'
		local
			l_area: like area; l_codec: like codec
			i, i_final: INTEGER
		do
			Result := Buffer_32.empty; l_codec := codec; l_area := cursor.area
			i_final := cursor.area_first_index + cursor.target_count
			from i := cursor.area_first_index until i = i_final loop
				Result.extend (l_codec.as_z_code (l_area [i]).to_character_32)
				i := i + 1
			end
		ensure
			same_count: Result.count = cursor.target_count
		end

	shared_search_pattern (str: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			if attached {EL_READABLE_ZSTRING} str as z_other then
				Result := z_other.as_expanded (1)

			elseif attached {READABLE_STRING_8} str as str_8 and then attached cursor_8 (str_8) as cursor then
				if cursor.all_ascii then
					Result := str_8
				else
					Result := shared_expanded_8 (cursor)
				end

			elseif attached {READABLE_STRING_32} str as str_32  then
				Result := shared_expanded_32 (str_32)
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
--					Result := mixed_encoding_substring_index (other, start_index, count)
					-- Make calls to `code' more efficient by caching calls to `unencoded_code' in expanded string
					Result := String_searcher.substring_index (current_readable, other.as_expanded (1), start_index, count)

				when Only_other then
					Result := 0
			else
			end
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

end