note
	description: "Comparable aspects of [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "12"

deferred class
	EL_COMPARABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

feature -- Status query

	matches (a_pattern: EL_TEXT_PATTERN_I): BOOLEAN
		do
			Result := a_pattern.matches_string_general (current_readable)
		end

feature -- Character comparison

	ends_with_character (c: CHARACTER_32): BOOLEAN
		do
			if not is_empty then
				Result := item (count) = c
			end
		end

	has_first (uc: CHARACTER_32): BOOLEAN
		do
			Result := not is_empty and then z_code (1) = uc.natural_32_code
		end

feature -- Start/End comparisons

	begins_with (str: READABLE_STRING_GENERAL): BOOLEAN
		-- True if left-adjusted string begins with `str'
		local
			white_count: INTEGER
		do
			white_count := leading_white_space
			if count - white_count >= str.count then
				Result := same_characters_general (str, 1, str.count, white_count + 1)
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

	ends_with (str: READABLE_STRING_32): BOOLEAN
		do
			Result := ends_with_general (str)
		end

	ends_with_general (str: READABLE_STRING_GENERAL): BOOLEAN
		local
			str_count, l_count: INTEGER
		do
			str_count := str.count; l_count := count
			if str = current_readable or else str_count = 0 then
				Result := True

			elseif attached {EL_READABLE_ZSTRING} str as z_str then
				Result := ends_with_ztring (z_str)

			elseif str.count <= count and then item (l_count - str_count + 1) = str [1]
				and then str_count > 1 implies item (l_count) = str [str_count]
			then
				Result := ends_with_ztring (adapted_argument (str, 1))
			end
		end

 	ends_with_ztring (str: EL_READABLE_ZSTRING): BOOLEAN
		do
			Result := internal_ends_with (str)
			if Result and then str.has_mixed_encoding then
				Result := Result and same_unencoded_substring (str, count - str.count + 1)
			end
		ensure
			definition: Result = str.same_string (substring (count - str.count + 1, count))
		end

 	starts_with (str: READABLE_STRING_32): BOOLEAN
		do
			Result := starts_with_general (str)
		end

 	starts_with_ztring (str: EL_READABLE_ZSTRING): BOOLEAN
		do
			Result := internal_starts_with (str)
			if Result and then str.has_mixed_encoding then
				Result := Result and same_unencoded_substring (str, 1)
			end
		ensure
			definition: Result = str.same_string (substring (1, str.count))
		end

	starts_with_general (str: READABLE_STRING_GENERAL): BOOLEAN
		local
			str_count: INTEGER
		do
			str_count := str.count
			if str = current_readable or else str_count = 0 then
				Result := True

			elseif attached {EL_READABLE_ZSTRING} str as z_str then
				Result := starts_with_ztring (z_str)

			elseif str.count <= count and then item (1) = str [1]
				and then str_count > 1 implies item (str_count) = str [str_count]
			then
				Result := starts_with_ztring (adapted_argument (str, 1))
			end
		end

feature -- Comparison

	same_caseless_characters (other: READABLE_STRING_32; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
		-- Are characters of `other' within bounds `start_pos' and `end_pos'
		-- caseless identical to characters of current string starting at index `index_pos'.
		do
 			if attached {EL_READABLE_ZSTRING} other as z_other then
 				Result := matching_characters_in_bounds (z_other, start_pos, end_pos, index_pos, False)
 			else
 				Result := same_caseless_characters_general (other, start_pos, end_pos, index_pos)
 			end
 		end

 	same_characters (other: READABLE_STRING_32; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `index_pos'.
		do
			if attached {EL_READABLE_ZSTRING} other as z_other then
				Result := matching_characters_in_bounds (z_other, start_pos, end_pos, index_pos, True)
			else
				Result := same_characters_general (other, start_pos, end_pos, index_pos)
			end
		end

	same_substring (str: READABLE_STRING_GENERAL; i: INTEGER; case_insensitive: BOOLEAN): BOOLEAN
		-- `True' if `str' occurs at position `i' with optional `case_insensitive' match
		do
			if case_insensitive then
				Result := same_caseless_characters_general (str, 1, str.count, i)
			else
				Result := same_characters_general (str, 1, str.count, i)
			end
		end

feature {NONE} -- Deferred

	leading_white_space: INTEGER
		deferred
		end

	same_caseless_characters_general (other: READABLE_STRING_GENERAL; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
		deferred
		end

	same_characters_general (other: READABLE_STRING_GENERAL; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
		deferred
		end

feature {NONE} -- Implementation

	matching_characters_in_bounds (
		other: EL_READABLE_ZSTRING; start_pos, end_pos, index_pos: INTEGER; case_sensitive: BOOLEAN
	): BOOLEAN
		-- Are characters of `other' within bounds `start_pos' and `end_pos'
		-- matching characters of current string starting at index `index_pos'
		local
			i, i_final: INTEGER; l_area, o_area: like area
			unencoded, o_unencoded: like unencoded_indexable
			uc, uc_other: CHARACTER_32
		do
			if case_sensitive then
				Result := internal_same_characters (other, start_pos, end_pos, index_pos)
			else
				Result := internal_same_caseless_characters (other, start_pos, end_pos, index_pos)
			end
			if Result and then has_mixed_encoding then
				unencoded := unencoded_indexable; o_unencoded := other.unencoded_indexable_other
				l_area := area; o_area := other.area
				i_final := end_pos - start_pos + 1
--				check substitutions
				from i := 0 until not Result or else i = i_final loop
					if l_area [index_pos + i - 1] = Substitute then
						uc := unencoded.item (index_pos + i); uc_other := o_unencoded.item (start_pos + i)
						if case_sensitive then
							Result := uc = uc_other
						else
							Result := uc.as_lower = uc_other.as_lower
						end
					end
					i := i + 1
				end
			end
		end

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

end