note
	description: "Read only interface to class [$source EL_ZSTRING]"
	tests: "Class [$source ZSTRING_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-20 12:03:38 GMT (Thursday 20th August 2020)"
	revision: "52"

deferred class
	EL_READABLE_ZSTRING

inherit
	READABLE_STRING_GENERAL
		rename
			code as z_code,
			same_caseless_characters as same_caseless_characters_general,
			substring_index as substring_index_general,
			ends_with as ends_with_general,
			is_case_insensitive_equal as is_case_insensitive_equal_general,
			starts_with as starts_with_general
		undefine
--			Access
			index_of, last_index_of, out,
--			Status query			
			has, is_double, is_real_64, is_integer, is_integer_32,
--			Conversion
			as_string_8, as_string_32,
			split,
			to_boolean, to_double, to_real_64, to_integer, to_integer_32,
			to_string_8, to_string_32,
--			Measurement
			occurrences
		redefine
--			Access
			hash_code,
--			Status query
			ends_with_general, starts_with_general,
--			Comparison
			is_equal, same_characters,
--			Duplication
			copy
		end

	EL_CONVERTABLE_ZSTRING
		redefine
			make_from_string
		end

	EL_MEASUREABLE_ZSTRING
		redefine
			make_from_string
		end

	EL_SEARCHABLE_ZSTRING
		redefine
			make_from_string
		end

	READABLE_INDEXABLE [CHARACTER_32]
		rename
			upper as count
		undefine
			out, copy, is_equal
		end

	STRING_HANDLER
		undefine
			is_equal, copy, out
		end

	DEBUG_OUTPUT
		rename
			debug_output as as_string_32
		undefine
			is_equal, copy, out
		end

	EL_SHARED_ZSTRING_CODEC

	EL_MODULE_CHAR_32

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Allocate space for at least `n' characters.
		do
			internal_make (n)
			make_unencoded
		end

	make_filled (uc: CHARACTER_32; n: INTEGER)
			-- Create string of length `n' filled with `uc'.
		require
			valid_count: n >= 0
		do
			make (n)
			fill_character (uc)
		ensure
			count_set: count = n
			area_allocated: capacity >= n
			filled: occurrences (uc) = count
		end

	make_from_latin_1_c (latin_1_ptr: POINTER)
		local
			latin: EL_STRING_8
		do
			latin := Latin_1_c_string
			latin.set_from_c (latin_1_ptr)
			make_from_general (latin)
		end

	make_from_other (other: EL_READABLE_ZSTRING)
		do
			area := other.area.twin
			count := other.count
			make_unencoded_from_other (other)
		end

	make_unescaped (unescaper: EL_ZSTRING_UNESCAPER; other: EL_READABLE_ZSTRING)
		local
			other_count, i, n, sequence_count: INTEGER; z_code_i, escape_code: NATURAL
			l_area, other_area: like area; l_unencoded: like extendible_unencoded
		do
			other_count := other.count; other_area := other.area
			l_unencoded := extendible_unencoded; escape_code := unescaper.escape_code

			make (other_count)
			l_area := area
			from i := 0 until i = other_count loop
				z_code_i := other.area_i_th_z_code (other_area, i)
				if z_code_i = escape_code then
					sequence_count := unescaper.sequence_count (other, i + 2)
					if sequence_count.to_boolean then
						z_code_i := unescaper.unescaped_z_code (other, i + 2, sequence_count)
					end
				else
					sequence_count := 0
				end
				if z_code_i > 0xFF then
					l_area [n] := Unencoded_character
					l_unencoded.extend_z_code (z_code_i, n + 1)
				else
					l_area [n] := z_code_i.to_character_8
				end
				i := i + sequence_count + 1
				n := n + 1
			end
			set_count (n)
			set_from_extendible_unencoded (l_unencoded)
			trim
		end

feature {NONE} -- Initialization

	make_from_general (s: READABLE_STRING_GENERAL)
		do
			if attached {EL_ZSTRING} s as other then
				make_from_other (other)
			else
				make_filled ('%U', s.count)
				encode (s, 0)
			end
		end

	make_from_string (s: STRING)
			-- initialize with string that has the same encoding as codec
		do
			Precursor (s)
			make_unencoded
		end

	make_from_utf_8 (a_utf_8: READABLE_STRING_8)
		do
			if attached {STRING} a_utf_8 as utf_8 then
				make_from_general (Utf_8_codec.as_unicode (utf_8, False))
			end
		end

	make_shared (other: like Current)
		do
			share (other)
		end

feature -- Access

	fuzzy_index (other: READABLE_STRING_GENERAL; start: INTEGER; fuzz: INTEGER): INTEGER
			-- <Precursor>
		do
			Result := string_searcher.fuzzy_index (Current, other, start, count, fuzz)
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := internal_hash_code
			if Result = 0 then
				Result := unencoded_hash_code (area_hash_code)
				internal_hash_code := Result
			end
		end

	share (other: like Current)
		do
			internal_share (other)
			unencoded_area := other.unencoded_area
		end

feature -- Output

	write_latin (writeable: EL_WRITEABLE)
		-- write `area' sequence as raw characters to `writeable'
		local
			i, l_count: INTEGER; l_area: like area
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				writeable.write_raw_character_8 (l_area [i])
				i := i + 1
			end
		end

feature -- Character status query

	is_alpha_item (i: INTEGER): BOOLEAN
		require
			valid_index: valid_index (i)
		do
			Result := is_area_alpha_item (area, i - 1)
		end

	is_alpha_numeric_item (i: INTEGER): BOOLEAN
		require else
			valid_index: valid_index (i)
		local
			c: CHARACTER
		do
			c := area [i - 1]
			if c = Unencoded_character then
				Result := unencoded_item (i).is_alpha_numeric
			else
				Result := codec.is_alphanumeric (c.natural_32_code)
			end
		end

	is_numeric_item (i: INTEGER): BOOLEAN
		require
			valid_index: valid_index (i)
		local
			c: CHARACTER
		do
			c := area [i - 1]
			if c = Unencoded_character then
				Result := Char_32.is_digit (unencoded_item (i))
			else
				Result := codec.is_numeric (c.natural_32_code)
			end
		end

	is_space_item (i: INTEGER): BOOLEAN
		require
			valid_index: valid_index (i)
		local
			c: CHARACTER
		do
			c := area [i - 1]
			if c = Unencoded_character then
				-- Because of a compiler bug we need `is_space_32'
				Result := is_space_32 (unencoded_item (i))
			else
				Result := c.is_space
			end
		end

feature -- Status query

	begins_with (str: READABLE_STRING_GENERAL): BOOLEAN
		-- True if left-adjusted string begins with `str'
		local
			white_count: INTEGER
		do
			white_count := leading_white_space
			if count - white_count >= str.count then
				Result := same_characters (str, 1, str.count, white_count + 1)
			end
		end

	enclosed_with (character_pair: EL_READABLE_ZSTRING): BOOLEAN
		require
			is_pair: character_pair.count = 2
		do
			if count >= 2 then
				Result := z_code (1) = character_pair.z_code (1) and then z_code (count) = character_pair.z_code (2)
			end
		end

	enclosed_with_general (character_pair: READABLE_STRING_GENERAL): BOOLEAN
		require
			is_pair: character_pair.count = 2
		do
			Result := enclosed_with (adapted_argument (character_pair, 1))
		end

	encoded_with (a_codec: EL_ZCODEC): BOOLEAN
		do
			Result := a_codec.same_type (codec)
		end

	ends_with (str: EL_READABLE_ZSTRING): BOOLEAN
		do
			Result := internal_ends_with (str)
			if Result and then str.has_mixed_encoding then
				Result := Result and same_unencoded_substring (str, count - str.count + 1)
			end
		end

	ends_with_character (c: CHARACTER_32): BOOLEAN
		do
			if not is_empty then
				Result := item (count) = c
			end
		end

	ends_with_general (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := ends_with (adapted_argument (str, 1))
		end

	extendible: BOOLEAN = True
			-- May new items be added? (Answer: yes.)

	for_all (start_index, end_index: INTEGER; condition: PREDICATE [CHARACTER_32]): BOOLEAN
		-- True if `condition' is true for all characters in range `start_index' .. `end_index'
		-- (when testing for whitespace, use `is_substring_whitespace', it's more efficient)
		require
			start_index_big_enough: 1 <= start_index
			end_index_small_enough: end_index <= count
			consistent_indexes: start_index - 1 <= end_index
		local
			c_i: CHARACTER; i: INTEGER; l_area: like area

		do
			l_area := area
			Result := True
			from i := start_index until not Result or else i > end_index loop
				c_i := l_area [i - 1]
				if c_i = Unencoded_character then
					Result := Result and condition (unencoded_item (i))
				else
					Result := Result and condition (codec.as_unicode_character (c_i))
				end
				i := i + 1
			end
		end

	has_first (uc: CHARACTER_32): BOOLEAN
		do
			Result := not is_empty and then z_code (1) = uc.natural_32_code
		end

	has_quotes (a_count: INTEGER): BOOLEAN
		require
			double_or_single: 1 <= a_count and a_count <= 2
		local
			quote_code: NATURAL
		do
			if a_count = 1 then
				quote_code := ('%'').natural_32_code
			else
				quote_code := ('"').natural_32_code
			end
			Result := count >= 2 and then z_code (1) = quote_code and then z_code (count) = quote_code
		end

	is_canonically_spaced: BOOLEAN
		-- `True' if the longest substring of whitespace consists of one space character
		local
			c_i: CHARACTER; i, l_count, space_count: INTEGER; l_area: like area
			is_space, is_space_state: BOOLEAN
		do
			l_area := area; l_count := count
			Result := True
			from i := 0 until not Result or else i = l_count loop
				c_i := l_area [i]
				if c_i = Unencoded_character then
					is_space := Char_32.is_space (unencoded_item (i)) -- Work around for finalization bug
				else
					is_space := c_i.is_space
				end
				if is_space then
					space_count := space_count + 1
					if c_i /= ' ' or else space_count = 2 then
						Result := False
					end
				end
				if is_space_state then
					if not is_space then
						is_space_state := False
					end
				elseif is_space then
					is_space_state := True
					space_count := 0
				end
				i := i + 1
			end
		end

	is_left_adjustable: BOOLEAN
		-- True if `left_adjust' will change the `count'
		do
			Result := not is_empty and then is_space_item (1)
		end

	is_right_adjustable: BOOLEAN
		-- True if `right_adjust' will change the `count'
		do
			Result := not is_empty and then is_space_item (count)
		end

	is_string_32: BOOLEAN = True
			-- <Precursor>

	is_string_8: BOOLEAN = False
			-- <Precursor>

	is_substring_whitespace (start_index, end_index: INTEGER): BOOLEAN
		local
			i: INTEGER; l_area: like area; c_i: CHARACTER
		do
			l_area := area
			if end_index = start_index - 1 then
				Result := False
			else
				Result := True
				from i := start_index - 1 until i = end_index or not Result loop
					c_i := l_area [i]
					if c_i = Unencoded_character then
						Result := Result and Char_32.is_space (unencoded_item (i + 1)) -- Work around for finalization bug
					else
						Result := Result and c_i.is_space
					end
					i := i + 1
				end
			end
		end

	is_valid_as_string_8: BOOLEAN
		do
			Result := not has_mixed_encoding
		end

	matches (a_pattern: EL_TEXT_PATTERN_I): BOOLEAN
		do
			Result := a_pattern.matches_string_general (Current)
		end

	prunable: BOOLEAN
			-- May items be removed? (Answer: yes.)
		do
			Result := True
		end

	starts_with (str: like Current): BOOLEAN
		do
			Result := internal_starts_with (str)
			if Result and then str.has_mixed_encoding then
				Result := Result and same_unencoded_substring (str, 1)
			end
		end

	starts_with_general (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := starts_with (adapted_argument (str, 1))
		end

	valid_code (a_code: NATURAL_32): BOOLEAN
			-- Is `a_code' a valid code for a CHARACTER_32?
		do
			Result := True
		end

feature -- Conversion

	substring (start_index, end_index: INTEGER): like Current
			-- Copy of substring containing all characters at indices
			-- between `start_index' and `end_index'
		do
			if (1 <= start_index) and (start_index <= end_index) and (end_index <= count) then
				Result := new_string (end_index - start_index + 1)
				Result.area.copy_data (area, start_index - 1, 0, end_index - start_index + 1)
				Result.set_count (end_index - start_index + 1)
			else
				Result := new_string (0)
			end
			if has_mixed_encoding and then overlaps_unencoded (start_index, end_index) then
				Result.set_from_extendible_unencoded (unencoded_substring (start_index, end_index))
			end
		ensure then
			unencoded_valid: Result.is_unencoded_valid
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		local
			l_count: INTEGER; l_hash, l_other_hash: like internal_hash_code
		do
			if other = Current then
				Result := True
			else
				l_count := count
				if l_count = other.count then
						-- Let's compare the content if and only if the hash_code are the same or not yet computed.
					l_hash := internal_hash_code
					l_other_hash := other.internal_hash_code
					if l_hash = 0 or else l_other_hash = 0 or else l_hash = l_other_hash then
						Result := same_string (other)
					end
				end
			end
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is string lexicographically lower than `other'?
		local
			other_count, l_count: INTEGER
		do
			if other /= Current then
				other_count := other.count
				l_count := count
				if has_mixed_encoding or else other.has_mixed_encoding then
					if other_count = l_count then
						Result := order_comparison (other_count, other) > 0
					else
						if l_count < other_count then
							Result := order_comparison (l_count, other) >= 0
						else
							Result := order_comparison (other_count, other) > 0
						end
					end
				else
					if other_count = l_count then
						Result := internal_order_comparison (other.area, area, other.area_lower, area_lower, other_count) > 0
					else
						if l_count < other_count then
							Result := internal_order_comparison (other.area, area, other.area_lower, area_lower, l_count) >= 0
						else
							Result := internal_order_comparison (other.area, area, other.area_lower, area_lower, other_count) > 0
						end
					end
				end
			end
		end

 	same_characters (other: READABLE_STRING_GENERAL; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `index_pos'.
		local
			i, other_i, l_count: INTEGER; l_area, other_area: like area
		do
			if attached {like Current} other as z_other then
				Result := internal_same_characters (z_other, start_pos, end_pos, index_pos)
				if has_mixed_encoding or else z_other.has_mixed_encoding then
					l_area := area; other_area := z_other.area
					l_count := end_pos - start_pos + 1
					from i := index_pos - 1; other_i := start_pos - 1 until not Result or else i = index_pos + l_count - 1 loop
						if l_area [i] = Unencoded_character then
							Result := unencoded_code (i + 1) = z_other.unencoded_code (other_i + 1)
						end
						i := i + 1; other_i := other_i + 1
					end
				end
			else
				Result := Precursor (other, start_pos, end_pos, index_pos)
			end
		end

feature {EL_READABLE_ZSTRING} -- Duplication

	copy (other: like Current)
			-- Reinitialize by copying the characters of `other'.
			-- (This is also used by `twin'.)
		local
			old_area: like area
		do
			if other /= Current then
				old_area := area
				standard_copy (other)
					-- Note: <= is needed as all Eiffel string should have an
					-- extra character to insert null character at the end.
				copy_area (old_area, other)
				make_unencoded_from_other (other)
				internal_hash_code := 0
			end
		ensure then
			new_result_count: count = other.count
			-- same_characters: For every `i' in 1..`count', `item' (`i') = `other'.`item' (`i')
		end

feature {EL_READABLE_ZSTRING, STRING_HANDLER} -- Access

	as_expanded (index: INTEGER): STRING_32
			-- Current expanded as `z_code' sequence
		require
			valid_index: 1 <= index and index <= 2
		do
			Result := Once_expanded_strings [index - 1]; Result.wipe_out
			fill_expanded (Result)
		end

feature -- Append to output

	append_to (output: like Current)
		do
			output.append (Current)
		end

	append_to_general (output: STRING_GENERAL)
		do
			if attached {EL_ZSTRING} output as str_z then
				append_to (str_z)

			elseif attached {STRING_32} output as str_32 then
				append_to_string_32 (str_32)

			elseif attached {STRING_8} output as str_8 then
				append_to_string_8 (str_8)
			end
		end

	append_to_string_32 (output: STRING_32)
		local
			old_count: INTEGER; area_out: SPECIAL [CHARACTER_32]
		do
			old_count := output.count
			output.grow (old_count + count)
			area_out := output.area

			codec.decode (count, area, area_out, old_count)
			write_unencoded (area_out, old_count)

			area_out [old_count + count] := '%U'
			output.set_count (old_count + count)
		end

	append_to_string_8 (output: STRING_8)
		local
			str_32: STRING_32
		do
			str_32 := empty_once_string_32
			append_to_string_32 (str_32)
			output.append_string_general (str_32)
		end

	append_to_utf_8 (utf_8_out: STRING_8)
		do
			Utf_8_codec.append_general_to_utf_8 (Current, utf_8_out)
		end

feature {NONE} -- Implementation

	current_readable: EL_READABLE_ZSTRING
		do
			Result := Current
		end

	fill_expanded (str: STRING_32)
		local
			i, l_count: INTEGER; c_i: CHARACTER
			l_area: like area; l_area_32: like once_string_32.area
		do
			l_count := count
			str.grow (l_count); str.set_count (l_count)

			l_area := area; l_area_32 := str.area
			from i := 0 until i = l_count loop
				c_i := l_area [i]
				if c_i = Unencoded_character then
					l_area_32 [i] := unencoded_z_code (i + 1).to_character_32
				else
					l_area_32 [i] := c_i
				end
				i := i + 1
			end
		end

	is_space_32 (uc: CHARACTER_32): BOOLEAN
		do
--			Does not work in 16.05 compiler
--			Result := uc.is_space
			Result := Unicode_property.is_space (uc)
		end

	internal_substring_index_list (str: EL_READABLE_ZSTRING): ARRAYED_LIST [INTEGER]
		local
			index, l_count, str_count: INTEGER
		do
			l_count := count; str_count := str.count
			Result := Once_substring_indices; Result.wipe_out
			if not str.is_empty then
				from index := 1 until index = 0 or else index > l_count - str_count + 1 loop
					if str_count = 1 then
						index := index_of_z_code (str.z_code (1), index)
					else
						index := substring_index (str, index)
					end
					if index > 0 then
						Result.extend (index)
						index := index + str_count
					end
				end
			end
		end

	order_comparison (n: INTEGER; other: EL_READABLE_ZSTRING): INTEGER
			-- Compare `n' characters from `area' starting at `area_lower' with
			-- `n' characters from and `other' starting at `other.area_lower'.
			-- 0 if equal, < 0 if `Current' < `other', > 0 if `Current' > `other'
		require
			other_not_void: other /= Void
			n_non_negative: n >= 0
			n_valid: n <= (area.upper - other.area_lower + 1) and n <= (other.area.upper - area_lower + 1)
		local
			i, j, nb, index_other, index: INTEGER; l_code, other_code: NATURAL; c_i, other_c_i: CHARACTER
			other_area, l_area: like area
		do
			l_area := area; other_area := other.area; index := area_lower; index_other := other.area_lower
			from i := index_other; nb := i + n; j := index until i = nb loop
				c_i := l_area [i]; other_c_i := other_area [i]

				if c_i = Unencoded_character then
					-- Do Unicode comparison
					l_code := unencoded_code (i + 1)
					if other_c_i = Unencoded_character then
						other_code := other.unencoded_code (i + 1)
					else
						other_code := codec.as_unicode_character (other_c_i).natural_32_code
					end
				else
					if other_c_i = Unencoded_character then
						-- Do Unicode comparison
						l_code := codec.as_unicode_character (c_i).natural_32_code
						other_code := other.unencoded_code (i + 1)
					else
						l_code := c_i.natural_32_code
						other_code := other_c_i.natural_32_code
					end
				end
				if l_code /= other_code then
					if l_code < other_code then
						Result := (other_code - l_code).to_integer_32
					else
						Result := -(l_code - other_code).to_integer_32
					end
					i := nb - 1 -- Jump out of loop
				end
				i := i + 1; j := j + 1
			end
		end

	reset_hash
		do
			internal_hash_code := 0
		end

	sum_count (cursor: ITERATION_CURSOR [READABLE_STRING_GENERAL]): INTEGER
		do
			from until cursor.after loop
				Result := Result + cursor.item.count
				cursor.forth
			end
		end

feature {NONE} -- Constants

	Latin_1_c_string: EL_STRING_8
		once
			create Result.make_empty
		end

	Unicode_property: CHARACTER_PROPERTY
			-- Property for Unicode characters.
		once
			create Result.make
		end

	Once_expanded_strings: SPECIAL [STRING_32]
		once
			create Result.make_filled (create {STRING_32}.make_empty, 2)
			Result [1] := create {STRING_32}.make_empty
		end

	Once_substring_indices: ARRAYED_LIST [INTEGER]
		do
			create Result.make (5)
		end

end
