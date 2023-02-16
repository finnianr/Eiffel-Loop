note
	description: "Comparable aspects of [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-16 9:53:41 GMT (Thursday 16th February 2023)"
	revision: "24"

deferred class
	EL_COMPARABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_SHARED_STRING_32_CURSOR

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
			Result := i > 0 and then item (i) = uc
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
				if attached {EL_READABLE_ZSTRING} character_pair as zstr then
					Result := z_code (1) = zstr.z_code (1) and then z_code (count) = zstr.z_code (2)
				else
					Result := item (1) = character_pair [1] and then item (count) = character_pair [2]
				end
			end
		end

	ends_with (other: READABLE_STRING_32): BOOLEAN
		local
			other_count: INTEGER
		do
			if attached {EL_READABLE_ZSTRING} other as z_other then
				Result := String_8.ends_with (Current, z_other)
				if Result and then z_other.has_mixed_encoding then
					Result := Result and same_unencoded_substring (z_other, count - z_other.count + 1)
				end

			elseif attached {READABLE_STRING_32} other as str_32 then
				other_count := other.count
				if other_count = 0 then
					Result := True

				elseif other.count > count then
					do_nothing
				else
					Result := same_characters (str_32, 1, other_count, count - other_count + 1)
				end
			end
		end

	ends_with_general (other: READABLE_STRING_GENERAL): BOOLEAN
		local
			other_count: INTEGER
		do
			if attached {READABLE_STRING_32} other as str_32 then
				Result := ends_with (str_32)

			elseif attached {READABLE_STRING_8} other as str_8 then
				other_count := str_8.count
				if other_count = 0 then
					Result := True

				elseif other_count <= count then
					Result := same_characters_8 (str_8, 1, other_count, count - other_count + 1, False)
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

			elseif attached {EL_READABLE_ZSTRING} other as z_other then
				Result := String_8.starts_with (Current, z_other)
				if Result and then z_other.has_mixed_encoding then
					Result := Result and same_unencoded_substring (z_other, 1)
				end

			else
				Result := same_characters (other, 1, other_count, 1)
			end
		end

	starts_with_general (other: READABLE_STRING_GENERAL): BOOLEAN
		local
			other_count: INTEGER
		do
			if attached {READABLE_STRING_32} other as str_32 then
				Result := starts_with (str_32)

			elseif attached {READABLE_STRING_8} other as str_8 then
				other_count := other.count
				if other_count = 0 then
					Result := True

				elseif other.count > count then
					do_nothing
				else
					Result := same_characters_8 (str_8, 1, other_count, 1, False)
				end
			end
		end

feature -- Comparison

	same_caseless_characters (other: READABLE_STRING_32; start_pos, end_pos, start_index: INTEGER): BOOLEAN
		-- Are characters of `other' within bounds `start_pos' and `end_pos'
		-- caseless identical to characters of current string starting at index `start_index'.
		do
 			if attached {EL_READABLE_ZSTRING} other as z_other then
 				Result := same_caseless_characters_in_bounds (z_other, start_pos, end_pos, start_index)
 			else
 				Result := same_characters_32 (other, start_pos, end_pos, start_index, True)
 			end
 		end

	same_caseless_characters_general (other: READABLE_STRING_GENERAL; start_pos, end_pos, start_index: INTEGER): BOOLEAN
		do
 			if attached {READABLE_STRING_32} other as other_32 then
				Result := same_caseless_characters (other_32, start_pos, end_pos, start_index)

			elseif attached {READABLE_STRING_8} other as str_8 then
				Result := same_characters_8 (str_8, start_pos, end_pos, start_index, True)
			end
		end

 	same_characters (other: READABLE_STRING_32; start_pos, end_pos, start_index: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `start_index'.
		do
			if attached {EL_READABLE_ZSTRING} other as z_other then
				Result := same_characters_in_bounds (z_other, start_pos, end_pos, start_index)

			else
				Result := same_characters_32 (other, start_pos, end_pos, start_index, False)
			end
		end

 	same_characters_general (other: READABLE_STRING_GENERAL; start_pos, end_pos, start_index: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `start_index'.
		do
 			if attached {READABLE_STRING_32} other as other_32 then
				Result := same_characters (other_32, start_pos, end_pos, start_index)

			elseif attached {READABLE_STRING_8} other as str_8 then
				Result := same_characters_8 (str_8, start_pos, end_pos, start_index, False)
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

feature {NONE} -- Deferred

	leading_white_space: INTEGER
		deferred
		end

feature {NONE} -- Implementation

	order_comparison (other: EL_READABLE_ZSTRING; n: INTEGER): INTEGER
			-- Compare `n' characters from `area' starting at `area_lower' with
			-- `n' characters from and `other' starting at `other.area_lower'.
			-- 0 if equal, < 0 if `Current' < `other', > 0 if `Current' > `other'
		require
			n_non_negative: n >= 0
			n_valid: n <= (area.upper - other.area_lower + 1) and n <= (other.area.upper - area_lower + 1)
		local
			i, j, i_final, l_code: INTEGER; found: BOOLEAN
			l_z_code, o_z_code: NATURAL; o_area, l_area: like area
			unencoded, o_unencoded: like unencoded_indexable
		do
			l_area := area; o_area := other.area
			if has_mixed_encoding or else other.has_mixed_encoding then
				unencoded := unencoded_indexable; o_unencoded := other.unencoded_indexable_other
				from i := area_lower; i_final := i + n; j := other.area_lower until found or else i = i_final loop
					l_z_code := area_z_code (l_area, unencoded, i)
					o_z_code := area_z_code (o_area, o_unencoded, j)
					if l_z_code /= o_z_code then
						found := True
					else
						i := i + 1; j := j + 1
					end
				end
			else
				from i := area_lower; i_final := i + n; j := other.area_lower until found or else i = i_final loop
					if l_area [i] /= o_area [j] then
						found := True
					else
						i := i + 1; j := j + 1
					end
				end
				l_z_code := l_area.item (i).natural_32_code
				o_z_code := o_area.item (j).natural_32_code
			end
			if found then
				-- Comparison must be done as unicode and never Latin-15
				l_code := Codec.z_code_as_unicode (l_z_code).to_integer_32
				Result := Codec.z_code_as_unicode (o_z_code).to_integer_32 - l_code
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

	same_caseless_characters_in_bounds (other: EL_READABLE_ZSTRING; start_pos, end_pos, start_index: INTEGER): BOOLEAN
		-- Are characters of `other' within bounds `start_pos' and `end_pos'
		-- caselessly matching characters of current string starting at index `start_index'
		local
			i, l_count: INTEGER; l_area, o_area: like area; l_codec: like codec
			uc, uc_other: CHARACTER_32; c, c_other: CHARACTER; current_has_unencoded, other_has_unencoded: BOOLEAN
			unencoded, o_unencoded: like unencoded_indexable; c32: EL_CHARACTER_32_ROUTINES
		do
			l_count := end_pos - start_pos + 1
			l_area := area; o_area := other.area; l_codec := codec

			current_has_unencoded := has_unencoded_between_optimal (l_area, start_index, start_index + l_count - 1)
			other_has_unencoded := other.has_unencoded_between_optimal (o_area, start_pos, end_pos)
			Result := True
			inspect current_other_bitmap (current_has_unencoded, other_has_unencoded)
				when Both_have_mixed_encoding  then
					unencoded := unencoded_indexable; o_unencoded := other.unencoded_indexable_other
					from i := 0 until not Result or else i = l_count loop
						c := l_area [start_index + i - 1]; c_other := o_area [i]
						if c = Substitute then
							uc := unencoded.item (start_index + i)
							if c_other = Substitute then
								uc_other := o_unencoded.item (start_pos + i)
								Result := c32.same_caseless (uc, uc_other)
							else
								Result := l_codec.same_caseless (c_other, c, uc)
							end

						elseif c_other = Substitute then
							uc_other := o_unencoded.item (start_pos + i)
							Result := l_codec.same_caseless (c, c_other, uc_other)
						else
							Result := l_codec.same_caseless (c, c_other, '%U')
						end
						i := i + 1
					end

				when Only_current then
					unencoded := unencoded_indexable
					from i := 0 until not Result or else i = l_count loop
						c := l_area [start_index + i - 1]; c_other := o_area [i]
						if c = Substitute then
							uc := unencoded.item (start_index + i)
							Result := l_codec.same_caseless (c_other, c, uc)
						else
							Result := l_codec.same_caseless (c, c_other, '%U')
						end

						i := i + 1
					end

				when Only_other then
					o_unencoded := other.unencoded_indexable_other
					from i := 0 until not Result or else i = l_count loop
						c := l_area [start_index + i - 1]; c_other := o_area [i]
						if c_other = Substitute then
							uc_other := o_unencoded.item (start_pos + i)
							Result := l_codec.same_caseless (c, c_other, uc_other)
						else
							Result := l_codec.same_caseless (c, c_other, '%U')
						end
						i := i + 1
					end

				when Neither then
					from i := 0 until not Result or else i = l_count loop
						Result := l_codec.same_caseless (l_area [start_index + i - 1], o_area [i], '%U')
						i := i + 1
					end
			else
			end
		end

	same_characters_in_bounds (other: EL_READABLE_ZSTRING; start_pos, end_pos, start_index: INTEGER): BOOLEAN
		-- Are characters of `other' within bounds `start_pos' and `end_pos'
		-- the same characters of current string starting at index `start_index'
		local
			i, l_count: INTEGER; l_area, o_area: like area
			unencoded, o_unencoded: like unencoded_indexable
			uc, uc_other: CHARACTER_32
		do
			l_area := area; o_area := other.area
			l_count := end_pos - start_pos + 1
			Result := internal_same_characters (other, start_pos, end_pos, start_index)
			if Result and then has_unencoded_between_optimal (l_area, start_index, start_index + l_count - 1) then
				if other.has_unencoded_between_optimal (o_area, start_pos, end_pos) then
					unencoded := unencoded_indexable; o_unencoded := other.unencoded_indexable_other
--					check substitutions
					from i := 0 until not Result or else i = l_count loop
						if l_area [start_index + i - 1] = Substitute then
							uc := unencoded.item (start_index + i); uc_other := o_unencoded.item (start_pos + i)
							Result := uc = uc_other
						end
						i := i + 1
					end
				else
					Result := False
				end
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