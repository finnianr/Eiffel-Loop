note
	description: "Comparable aspects of [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-18 16:22:29 GMT (Saturday 18th November 2023)"
	revision: "38"

deferred class
	EL_COMPARABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_READABLE_ZSTRING_I

feature -- Status query

	matches (a_pattern: EL_TEXT_PATTERN_I): BOOLEAN
		do
			Result := a_pattern.matches_string_general (current_readable)
		end

feature -- Character comparison

	ends_with_character (uc: CHARACTER_32): BOOLEAN
		-- `True' if last character in string is same as `uc'
		local
			i: INTEGER
		do
			i := count
			if i > 0 then
				if uc.natural_32_code <= 0x7F then
				-- ASCII
					Result := area [i - 1] = uc.to_character_8
				else
					Result := item (i) = uc
				end
			end
		end

	has_first (uc: CHARACTER_32): BOOLEAN
		-- `True' if first character in string is same as `uc'
		do
			Result := count > 0 and then item (1) = uc
		end

	is_character (uc: CHARACTER_32): BOOLEAN
		-- `True' if string is same as single character `uc'
		do
			Result := count = 1 and then item (1) = uc
		end

	starts_with_character (uc: CHARACTER_32): BOOLEAN
		-- `True' if last character in string is same as `uc'
		do
			if count > 0 then
				if uc.natural_32_code <= 0x7F then
				-- ASCII
					Result := area [0] = uc.to_character_8
				else
					Result := item (1) = uc
				end
			end
		end

feature -- Start/End comparisons

	begins_with (str: READABLE_STRING_GENERAL): BOOLEAN
		-- True if left-adjusted string begins with `str'
		local
			white_count: INTEGER
		do
			if str.count = 0 then
				Result := True
			else
				white_count := leading_white_space
				if count - white_count >= str.count then
					Result := same_characters_general (str, 1, str.count, white_count + 1)
				end
			end
		end

	enclosed_with (character_pair: READABLE_STRING_GENERAL): BOOLEAN
		require
			is_pair: character_pair.count = 2
		do
			if count >= 2 and then character_pair.count = 2 then
				inspect Class_id.character_bytes (character_pair)
					when 'X' then
						if attached {EL_READABLE_ZSTRING} character_pair as zstr then
							Result := z_code (1) = zstr.z_code (1) and then z_code (count) = zstr.z_code (2)
						end
				else
					Result := item (1) = character_pair [1] and then item (count) = character_pair [2]
				end
			end
		end

	ends_with (other: READABLE_STRING_32): BOOLEAN
		local
			other_count: INTEGER
		do
			other_count := other.count
			if other_count = 0 then
				Result := True

			elseif other.count > count then
				do_nothing

			else
				inspect Class_id.character_bytes (other)
					when 'X' then
						if attached {EL_READABLE_ZSTRING} other as z_other then
							Result := same_characters_zstring (z_other, 1, other.count, count - other_count + 1)
						end
				else
					Result := same_characters_32 (other, 1, other_count, count - other_count + 1, False)
				end
			end
		end

	ends_with_general (other: READABLE_STRING_GENERAL): BOOLEAN
		local
			other_count: INTEGER
		do
			other_count := other.count
			inspect Class_id.character_bytes (other)
				when '1' then
					if attached {READABLE_STRING_8} other as str_8 then
						if other_count = 0 then
							Result := True

						elseif other_count <= count then
							Result := same_characters_8 (str_8, 1, other_count, count - other_count + 1, False)
						end
					end
				when '4' then
					if attached {READABLE_STRING_32} other as str_32 then
						Result := same_characters_32 (str_32, 1, other_count, count - other_count + 1, False)
					end
				when 'X' then
					if attached {EL_READABLE_ZSTRING} other as z_other then
						Result := same_characters_zstring (z_other, 1, other_count, count - other_count + 1)
					end
			end
		end

	starts_with (other: READABLE_STRING_32): BOOLEAN
		local
			other_count: INTEGER
		do
			other_count := other.count
			if other_count = 0 then
				Result := True

			elseif other_count > count then
				do_nothing

			else
				inspect Class_id.character_bytes (other)
					when 'X' then
						if attached {EL_READABLE_ZSTRING} other as z_other then
							Result := same_characters_zstring (z_other, 1, other.count, 1)
						end
				else
					Result := same_characters_32 (other, 1, other_count, 1, False)
				end
			end
		end

	starts_with_general (other: READABLE_STRING_GENERAL): BOOLEAN
		local
			other_count: INTEGER
		do
			inspect Class_id.character_bytes (other)
				when '1' then
					if attached {READABLE_STRING_8} other as str_8 then
						other_count := other.count
						if other_count = 0 then
							Result := True

						elseif other.count > count then
							do_nothing
						else
							Result := same_characters_8 (str_8, 1, other_count, 1, False)
						end
					end
				when '4' then
					if attached {READABLE_STRING_32} other as str_32 then
						Result := starts_with (str_32)
					end
				when 'X' then
					if attached {EL_READABLE_ZSTRING} other as zstr then
						Result := same_characters_zstring (zstr, 1, other.count, 1)
					end
			end
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is string lexicographically lower than `other'?
		local
			o_count, l_count: INTEGER
		do
			if other /= Current then
				o_count := other.count; l_count := count
				if o_count = l_count then
					Result := order_comparison (other, 1, 1, o_count) > 0
				else
					if l_count < o_count then
						Result := order_comparison (other, 1, 1, l_count) >= 0
					else
						Result := order_comparison (other, 1, 1, o_count) > 0
					end
				end
			end
		end

	same_caseless_characters (other: READABLE_STRING_32; start_pos, end_pos, start_index: INTEGER): BOOLEAN
		-- Are characters of `other' within bounds `start_pos' and `end_pos'
		-- caseless identical to characters of current string starting at index `start_index'.
		do
			inspect Class_id.character_bytes (other)
				when 'X' then
					if attached {EL_READABLE_ZSTRING} other as zstr then
						Result := same_caseless_characters_zstring (zstr, start_pos, end_pos, start_index)
					end
			else
				Result := same_characters_32 (other, start_pos, end_pos, start_index, True)
			end
		end

	same_caseless_characters_general (other: READABLE_STRING_GENERAL; start_pos, end_pos, start_index: INTEGER): BOOLEAN
		do
			inspect Class_id.character_bytes (other)
				when '1' then
					if attached {READABLE_STRING_8} other as str_8 then
						Result := same_characters_8 (str_8, start_pos, end_pos, start_index, True)
					end
				when '4' then
					if attached {READABLE_STRING_32} other as str_32 then
						Result := same_characters_32 (str_32, start_pos, end_pos, start_index, True)
					end
				when 'X' then
					if attached {EL_READABLE_ZSTRING} other as zstr then
						Result := same_characters_zstring (zstr, start_pos, end_pos, start_index)
					end
			end
		end

	same_characters (other: READABLE_STRING_32; start_pos, end_pos, start_index: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `start_index'.
		do
			inspect Class_id.character_bytes (other)
				when 'X' then
					if attached {EL_READABLE_ZSTRING} other as zstr then
						Result := same_characters_zstring (zstr, start_pos, end_pos, start_index)
					end
			else
				Result := same_characters_32 (other, start_pos, end_pos, start_index, False)
			end
		end

	same_characters_general (other: READABLE_STRING_GENERAL; start_pos, end_pos, start_index: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `start_index'.
		do
			inspect Class_id.character_bytes (other)
				when '1' then
					if attached {READABLE_STRING_8} other as str_8 then
						Result := same_characters_8 (str_8, start_pos, end_pos, start_index, False)
					end
				when '4' then
					if attached {READABLE_STRING_32} other as str_32 then
						Result := same_characters_32 (str_32, start_pos, end_pos, start_index, False)
					end
				when 'X' then
					if attached {EL_READABLE_ZSTRING} other as zstr then
						Result := same_characters_zstring (zstr, start_pos, end_pos, start_index)
					end
			end
		end

	same_substring (str: READABLE_STRING_GENERAL; i: INTEGER; case_insensitive: BOOLEAN): BOOLEAN
		-- `True' if `str' occurs at position `i' with optional `case_insensitive' match
		do
			if str.count = 0 then
				Result := True
			else
				if case_insensitive then
					Result := same_caseless_characters_general (str, 1, str.count, i)
				else
					Result := same_characters_general (str, 1, str.count, i)
				end
			end
		end

feature {NONE} -- Implementation

	order_comparison (other: EL_COMPARABLE_ZSTRING; start_index, other_start_index, n: INTEGER): INTEGER
			-- Compare `n' characters from `other' starting at `other_start_index' with
			-- `n' characters from `Current' starting as `start_index'
			-- 0 if equal, < 0 if `Current' < `other', > 0 if `Current' > `other'
		require
			n_non_negative: n >= 0
			valid_start_index: valid_index (start_index) and valid_index (other_start_index)
			valid_n_count: valid_index (start_index + n - 1) and valid_index (other_start_index + n - 1)
		local
			i, j, i_final, block_index, other_block_index: INTEGER; found: BOOLEAN
			uc_i, o_uc_i: CHARACTER_32; l_code, o_code: NATURAL; c_i, o_i: CHARACTER
			o_unencoded, unencoded: like unencoded_area; o_area, l_area: like area
			iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			l_area := area; o_area := other.area
			unencoded := unencoded_area; o_unencoded := other.unencoded_area
			i_final := area_lower + other_start_index + n - 1
			j := other.area_lower + other_start_index - 1
			from i := area_lower + start_index - 1 until found or else i = i_final loop
				c_i := l_area [i]; o_i := o_area [j]
				inspect current_other_bitmap (c_i = Substitute, o_i = Substitute)
					when Both_have_mixed_encoding then
						uc_i := iter.item ($block_index, unencoded, i + 1)
						o_uc_i := iter.item ($other_block_index, o_unencoded, j + 1)
						if uc_i /= o_uc_i then
							l_code := unicode_to_z_code (uc_i.natural_32_code)
							o_code := unicode_to_z_code (o_uc_i.natural_32_code)
							found := True
						end
					when Only_current then
						uc_i := iter.item ($block_index, unencoded, i + 1)
						l_code := unicode_to_z_code (uc_i.natural_32_code); o_code := o_i.natural_32_code
						found := True

					when Only_other then
						o_uc_i := iter.item ($other_block_index, o_unencoded, j + 1)
						l_code := c_i.natural_32_code; o_code := unicode_to_z_code (o_uc_i.natural_32_code)
						found := True

					when Neither then
						if c_i /= o_i then
							l_code := c_i.natural_32_code; o_code := o_i.natural_32_code
							found := True
						end
				else
				end
				i := i + 1; j := j + 1
			end
			if found then
				Result := Codec.order_comparison (l_code, o_code)
			end
		end

	same_caseless_characters_zstring (other: EL_READABLE_ZSTRING; start_pos, end_pos, start_index: INTEGER): BOOLEAN
		-- Are characters of `other' within bounds `start_pos' and `end_pos'
		-- caselessly matching characters of current string starting at index `start_index'
		local
			l_count: INTEGER
		do
			l_count := end_pos - start_pos + 1
			if start_index + l_count - 1 <= count
				and then codec.same_caseless_characters (area, other.area, start_pos - start_index, start_index - 1, l_count)
			then
				Result := same_unencoded_characters (
					other.unencoded_area, start_index, start_index + l_count - 1, start_pos - start_index, True
				)
			end
		end

	same_characters_8 (
		other: READABLE_STRING_8; start_pos, end_pos, start_index: INTEGER; case_insensitive: BOOLEAN
	): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `start_index'.
		local
			end_index: INTEGER
		do
			end_index := start_index + end_pos - start_pos
			if end_index <= count and then
				attached shared_comparator_string_8 (start_index, end_index, case_insensitive) as list
			then
				list.set_other_area (cursor_8 (other))
				Result := list.same_characters (area, start_pos - start_index)
			end

		end

	same_characters_32 (
		other: READABLE_STRING_32; start_pos, end_pos, start_index: INTEGER; case_insensitive: BOOLEAN
	): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `start_index'.
		local
			end_index: INTEGER
		do
			end_index := start_index + end_pos - start_pos
			if end_index <= count and then
				attached shared_comparator_string_32 (start_index, end_index, case_insensitive) as list
			then
				list.set_other_area (cursor_32 (other))
				Result := list.same_characters (area, start_pos - start_index)
			end

		end

	same_characters_zstring (other: EL_READABLE_ZSTRING; start_pos, end_pos, start_index: INTEGER): BOOLEAN
		-- Are characters of `other' within bounds `start_pos' and `end_pos'
		-- the same characters of current string starting at index `start_index'
		local
			end_index: INTEGER
		do
			end_index := start_index + end_pos - start_pos
			if end_index <= count and then internal_same_characters (other, start_pos, end_pos, start_index) then
				Result := same_unencoded_characters (
					other.unencoded_area, start_index, end_index, start_pos - start_index, False
				)
			end
		end

	shared_comparator_string_8 (
		start_index, end_index: INTEGER; case_insensitive: BOOLEAN
	): EL_COMPARE_ZSTRING_TO_STRING_8
		do
			if case_insensitive then
				Result := Caseless_comparator_string_8
			else
				Result := Comparator_string_8
			end
			Result.set (unencoded_area, start_index, end_index)
		end

	shared_comparator_string_32 (
		start_index, end_index: INTEGER; case_insensitive: BOOLEAN
	): EL_COMPARE_ZSTRING_TO_STRING_32
		do
			if case_insensitive then
				Result := Caseless_comparator_string_32
			else
				Result := Comparator_string_32
			end
			Result.set (unencoded_area, start_index, end_index)
		end

feature {NONE} -- Constants

	Comparator_string_32: EL_COMPARE_ZSTRING_TO_STRING_32
		once
			create Result.make
		end

	Comparator_string_8: EL_COMPARE_ZSTRING_TO_STRING_8
		once
			create Result.make
		end

	Caseless_comparator_string_32: EL_CASELESS_COMPARE_ZSTRING_TO_STRING_32
		once
			create Result.make
		end

	Caseless_comparator_string_8: EL_CASELESS_COMPARE_ZSTRING_TO_STRING_8
		once
			create Result.make
		end

end