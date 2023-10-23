note
	description: "Read only interface to class [$source ZSTRING]"
	tests: "Class [$source ZSTRING_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-21 13:04:26 GMT (Saturday 21st October 2023)"
	revision: "130"

deferred class
	EL_READABLE_ZSTRING

inherit
	READABLE_STRING_32
		rename
			area as unencoded_area,
			code as z_code,
			has_code as has_unicode,
			make_from_string_general as make_from_general,
			split as split_list,
			string_searcher as string_32_searcher,
			to_lower_area as unencoded_to_lower_area,
			to_upper_area as unencoded_to_upper_area
		export
			{NONE} unencoded_to_lower_area, unencoded_to_upper_area
		undefine
--			Initialization
			make,
--			Access
			area_lower, area_upper, fuzzy_index, index_of, last_index_of, out,
			substring_index_in_bounds, substring_index, string,
--			Status query			
			has, ends_with, ends_with_general, starts_with, starts_with_general, is_less,
			is_boolean, is_real, is_real_32, is_double, is_real_64,
			is_integer_8, is_integer_16, is_integer, is_integer_32, is_integer_64,
			is_natural_8, is_natural_16, is_natural, is_natural_32, is_natural_64,
			is_substring_whitespace, is_valid_as_string_8, valid_code,
--			Conversion
			as_string_8, as_string_32, split_list,
			to_boolean, to_real, to_real_32, to_double, to_real_64,
			to_integer_8, to_integer_16, to_integer, to_integer_32, to_integer_64,
			to_natural_8, to_natural_16, to_natural, to_natural_32, to_natural_64,
			to_string_8, to_string_32,
--			Comparison
			same_caseless_characters, same_characters, same_characters_general, same_caseless_characters_general,
--			Element change
			fill_character,
--			Measurement
			capacity, occurrences,
--			Implementation
			is_valid_integer_or_natural
		redefine
--			Initialization
			make_from_string,
--			Access
			hash_code, unencoded_area, new_cursor,
--			Status query
			has_unicode,
--			Comparison
			is_equal,
--			Duplication
			copy
		end

	EL_COMPARABLE_ZSTRING
		export
			{STRING_HANDLER, EL_OCCURRENCE_INTERVALS}
				empty_unencoded_buffer, item_8, set_unencoded_from_buffer, order_comparison
			{EL_ZSTRING_ITERATION_CURSOR, EL_STRING_8_IMPLEMENTATION}
				area_lower, area_upper, area, unencoded_area
			{EL_ZSTRING_IMPLEMENTATION}
				unencoded_i_th_substring, unencoded_first_lower, unencoded_first_upper, unencoded_interval_sequence,
				unencoded_fill_list
			{EL_ZCODEC} codec
		redefine
			unencoded_area
		end

	EL_CONVERTABLE_ZSTRING
		redefine
			unencoded_area
		end

	EL_MEASUREABLE_ZSTRING
		redefine
			unencoded_area
		end

	EL_SEARCHABLE_ZSTRING
		export
			{EL_APPENDABLE_ZSTRING} internal_substring_index_list
			{EL_ZSTRING_CONSTANTS} String_searcher
		redefine
			unencoded_area
		end

	EL_ZSTRING_TO_BASIC_TYPES
		redefine
			unencoded_area
		end

	READABLE_INDEXABLE [CHARACTER_32]
		rename
			upper as count
		undefine
			out, copy, is_equal
		redefine
			new_cursor
		end

	EL_SHARED_IMMUTABLE_8_MANAGER

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Allocate space for at least `n' characters.
		do
			internal_make (n)
			make_unencoded
		end

	make_from_latin_1_c (latin_1_ptr: POINTER)
		local
			latin: EL_STRING_8
		do
			latin := String_8.c_string (latin_1_ptr)
			if latin.is_ascii then
				make_unencoded
				set_from_ascii (latin)
			else
				make_from_general (latin)
			end
		end

	make_from_other (other: EL_READABLE_ZSTRING)
		do
			area := other.area.twin
			count := other.count
			make_unencoded_from_other (other)
		end

	make_from_zcode_area (zcode_area: SPECIAL [NATURAL])
		local
			z_code_i: NATURAL; i, l_count, last_upper: INTEGER
		do
			l_count := zcode_area.count
			make (l_count)
			if attached empty_unencoded_buffer as buffer and then attached area as l_area then
				last_upper := buffer.last_upper
				from i := 0 until i = l_count loop
					z_code_i := zcode_area [i]
					if z_code_i > 0xFF then
						l_area [i] := Substitute
						last_upper := buffer.extend_z_code (z_code_i, last_upper, i + 1)
					else
						l_area [i] := z_code_i.to_character_8
					end
					i := i + 1
				end
				set_count (l_count)
				buffer.set_last_upper (last_upper)
				set_unencoded_from_buffer (buffer)
			end
		end

feature {NONE} -- Initialization

	make_from_cil (a_system_string: detachable SYSTEM_STRING)
		do
		end

	make_from_file (text: STRING)
		-- make from full file `text' which may have a BOM mark indicating it is encoded as
		-- either: UTF-8, little-endian UTF-16 or else Latin-1
		local
			utf: EL_UTF_CONVERTER
		do
			if utf.is_utf_8_file (text) then
				make_from_utf_8 (utf.bomless_utf_8 (text))

			elseif utf.is_utf_16_le_file (text) then
				make_from_utf_16_le (utf.bomless_utf_16_le (text))

			else
				make_filled ('%U', text.count)
				encode (text, 0)
			end
		end

	make_from_general (s: READABLE_STRING_GENERAL)
		do
			if attached {EL_ZSTRING} s as other then
				make_from_other (other)
			else
				make_filled ('%U', s.count)
				encode (s, 0)
			end
		end

	make_from_string (s: READABLE_STRING_32)
		do
			if attached {EL_READABLE_ZSTRING} s as other then
				make_from_other (other)
			else
				make_filled ('%U', s.count)
				encode (s, 0)
			end
		end

	make_from_string_8 (str: READABLE_STRING_8)
			-- initialize with string that has the same encoding as codec
		require else
			must_not_have_reserved_substitute_character: not str.has ('%/026/')
		do
			make_unencoded
			String_8.make_from_string (Current, str)
		end

	make_from_substring (general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
		require
			valid_end_index: end_index <= general.count
		local
			l_count: INTEGER
		do
			l_count := end_index - start_index + 1
			if l_count < 1 then
				make_empty
			else
				make (l_count)
				if attached {EL_ZSTRING} general as other then
					append_substring (other, start_index, end_index)
				else
					append_substring_general (general, start_index, end_index)
				end
			end
		end

	make_from_utf_8 (utf_8_string: READABLE_STRING_8)
		local
			utf_8: EL_UTF_8_CONVERTER; unicode_count: INTEGER
		do
			unicode_count := utf_8.unicode_count (utf_8_string)
			make (unicode_count)
			internal_append_utf (utf_8_string, 8, unicode_count)
		end

	make_from_utf_16_le (utf_16_le_string: READABLE_STRING_8)
		local
			utf_16_le: EL_UTF_16_LE_CONVERTER; unicode_count: INTEGER
		do
			unicode_count := utf_16_le.unicode_count (utf_16_le_string)
			make (unicode_count)
			internal_append_utf (utf_16_le_string, 16, unicode_count)
		end

	make_shared (other: like Current)
		do
			share (other)
		end

feature -- Access

	fuzzy_index (other: READABLE_STRING_GENERAL; start_index: INTEGER; fuzz: INTEGER): INTEGER
			-- <Precursor>
		do
			Result := string_searcher.fuzzy_index (Current, other, start_index, count, fuzz)
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

	new_cursor: EL_ZSTRING_ITERATION_CURSOR
		do
			create Result.make (Current)
			Result.start
		end

	share (other: like Current)
		do
			internal_share (other)
			unencoded_area := other.unencoded_area
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
			if c = Substitute then
				Result := unencoded_item (i).is_alpha_numeric

			elseif c <= Max_7_bit_character then
				Result := c.is_alpha_numeric

			else
				Result := Codec.is_alphanumeric (c.natural_32_code)
			end
		end

	is_numeric_item (i: INTEGER): BOOLEAN
		require
			valid_index: valid_index (i)
		local
			c_i: CHARACTER; c32: EL_CHARACTER_32_ROUTINES
		do
			c_i := area [i - 1]
			if c_i = Substitute then
				Result := c32.is_digit (unencoded_item (i))

			elseif c_i <= Max_7_bit_character then
				Result := c_i.is_digit

			else
				Result := Codec.is_numeric (c_i.natural_32_code)
			end
		end

	is_space_item (i: INTEGER): BOOLEAN
		require
			valid_index: valid_index (i)
		local
			c: CHARACTER; c32: EL_CHARACTER_32_ROUTINES
		do
			c := area [i - 1]
			if c = Substitute then
				-- Because of a compiler bug we need `is_space_32'
				Result := c32.is_space (unencoded_item (i))
			else
				Result := c.is_space
			end
		end

feature -- Status query

	encoded_with (a_codec: EL_ZCODEC): BOOLEAN
		do
			Result := a_Codec.same_type (codec)
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
			i: INTEGER; l_area: like area; c: CHARACTER
		do
			l_area := area
			Result := True
			from i := start_index until not Result or else i > end_index loop
				c := l_area [i - 1]
				if c = Substitute then
					Result := Result and condition (unencoded_item (i))

				elseif c <= Max_7_bit_character then
					Result := Result and condition (c.to_character_32)

				else
					Result := Result and condition (Unicode_table [c.code])
				end
				i := i + 1
			end
		end

	has_alpha_numeric: BOOLEAN
		-- `True' if `str' has an alpha numeric character
		local
			c_i: CHARACTER; i, block_index, i_final: INTEGER; iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			if attached unencoded_area as area_32 and then attached area as l_area
				and then attached Codec as l_codec
			then
				i_final := count
				from i := 0 until Result or else i = i_final loop
					c_i := l_area [i]
					if c_i = Substitute then
						Result := iter.item ($block_index, area_32, i + 1).is_alpha_numeric

					elseif c_i <= Max_7_bit_character then
						Result := c_i.is_alpha_numeric

					else
						Result := l_codec.is_alphanumeric (c_i.natural_32_code)
					end
					i := i + 1
				end
			end
		end

	has_between (uc: CHARACTER_32; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `uc' occurs between `start_index' and `end_index'
		require
			valid_start_index: valid_index (start_index)
			valid_end_index: end_index >= start_index and end_index <= count
		local
			i: INTEGER; c: CHARACTER
		do
			c := codec.encoded_character (uc)
			if c = Substitute then
				Result := unencoded_has_between (uc, start_index, end_index)

			elseif attached area as l_area then
				from i := start_index - 1 until i = end_index or Result loop
					Result := l_area [i] = c
					i := i + 1
				end
			end
		end

	has_unicode (uc: like unicode): BOOLEAN
		do
			Result := has_z_code (unicode_to_z_code (uc))
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

	is_space_filled: BOOLEAN
		do
			if count = 0 then
				Result := True
			else
				Result := is_substring_whitespace (1, count)
			end
		end

	is_canonically_spaced: BOOLEAN
		-- `True' if the longest substring of whitespace consists of one space character (ASCII 32)
		local
			c_i: CHARACTER; uc_i: CHARACTER_32; i, i_final, space_count, block_index: INTEGER
			iter: EL_UNENCODED_CHARACTER_ITERATION; c32: EL_CHARACTER_32_ROUTINES
			is_space: BOOLEAN
		do
			if attached area as l_area and then attached unencoded_area as area_32 then
				Result := True; i_final := count
				from i := 0 until not Result or else i = i_final loop
					c_i := l_area [i]
					if c_i = Substitute then
						uc_i := iter.item ($block_index, area_32, i + 1)
					-- `c32.is_space' is workaround for finalization bug
						is_space := c32.is_space (uc_i)
					else
						is_space := c_i.is_space
					end
					if is_space then
						space_count := space_count + 1
					else
						space_count := 0
					end
					inspect space_count
						when 0 then
							do_nothing
						when 1 then
							Result := c_i = ' '
					else
						Result := False
					end
					i := i + 1
				end
			end
		end

	is_code_identifier: BOOLEAN
		-- is C, Eiffel or other language identifier
		local
			i, l_count: INTEGER; l_area: like area
		do
			l_area := area; l_count := count
			if l_count > 0 then
				Result := True
				from i := 0 until not Result or else i = l_count loop
					inspect l_area [i]
						when 'a' .. 'z', 'A' .. 'Z' then
							do_nothing

						when '0' .. '9', '_' then
							Result := i > 0
					else
						Result := False
					end
					i := i + 1
				end
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

	is_substring_whitespace (start_index, end_index: INTEGER): BOOLEAN
		local
			i: INTEGER; l_area: like area; c_i: CHARACTER
			c: EL_CHARACTER_32_ROUTINES
		do
			l_area := area
			if end_index = start_index - 1 then
				Result := False
			else
				Result := True
				from i := start_index - 1 until i = end_index or not Result loop
					c_i := l_area [i]
					if c_i = Substitute then
						Result := Result and c.is_space (unencoded_item (i + 1)) -- Work around for finalization bug
					else
						Result := Result and c_i.is_space
					end
					i := i + 1
				end
			end
		end

	is_valid_as_string_8: BOOLEAN
		do
			Result := Latin_1_codec.is_encodeable_as_string_8 (Current, 1, count)
		end

	prunable: BOOLEAN
			-- May items be removed? (Answer: yes.)
		do
			Result := True
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
			if has_unencoded_between_optimal (area, start_index, end_index)
				and then attached empty_unencoded_buffer as buffer
			then
				buffer.append_substring (Current, start_index, end_index, 0)
				Result.set_unencoded_from_buffer (buffer)
			end
		ensure then
			unencoded_valid: Result.is_valid
		end

	substring_to (uc: CHARACTER_32; start_index_int32_ptr: POINTER): like Current
		-- substring from INTEGER at memory location `start_index_int32_ptr' up to but not including index of `uc'
		-- or else `substring_end (start_index)' if `uc' not found
		-- `start_index' is 1 if `start_index_int32_ptr = Default_pointer'
		-- write new start_index back to `start_index_int32_ptr'
		-- if `uc' not found then new `start_index' is `count + 1'
		local
			start_index, index: INTEGER
		do
			if start_index_int32_ptr = Default_pointer then
				start_index := 1
			else
				start_index := pointer.read_integer_32 (start_index_int32_ptr)
			end
			index := index_of (uc, start_index)
			if index > 0 then
				Result := substring (start_index, index - 1)
				start_index := index + 1
			else
				Result := substring_end (start_index)
				start_index := count + 1
			end
			if start_index_int32_ptr /= Default_pointer then
				pointer.put_integer_32 (start_index, start_index_int32_ptr)
			end
		end

	substring_to_reversed (uc: CHARACTER_32; start_index_from_end_ptr: POINTER): like Current
		-- the same as `substring_to' except going from right to left
		-- if `uc' not found `start_index_from_end' is set to `0' and written back to `start_index_from_end_ptr'
		local
			start_index_from_end, index: INTEGER
		do
			if start_index_from_end_ptr = Default_pointer then
				start_index_from_end := count
			else
				start_index_from_end := pointer.read_integer_32 (start_index_from_end_ptr)
			end
			index := last_index_of (uc, start_index_from_end)
			if index > 0 then
				Result := substring (index + 1, start_index_from_end)
				start_index_from_end := index - 1
			else
				Result := substring (1, start_index_from_end)
				start_index_from_end := 0
			end
			if start_index_from_end_ptr /= Default_pointer then
				pointer.put_integer_32 (start_index_from_end, start_index_from_end_ptr)
			end
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

feature {EL_ZSTRING_IMPLEMENTATION} -- Duplication

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

feature {STRING_HANDLER} -- Access

	frozen set_count (number: INTEGER)
			-- Set `count' to `number' of characters.
		do
			count := number
			reset_hash
		end

feature {NONE} -- Implementation

	current_zstring: ZSTRING
		deferred
		end

	current_readable: EL_READABLE_ZSTRING
		do
			Result := Current
		end

	pointer: EL_POINTER_ROUTINES
		-- expanded instance
		do
		end

	reset_hash
		do
			internal_hash_code := 0
			internal_case_insensitive_hash_code := 0
		end

	sum_count (cursor: ITERATION_CURSOR [READABLE_STRING_GENERAL]): INTEGER
		do
			from until cursor.after loop
				Result := Result + cursor.item.count
				cursor.forth
			end
		end

feature {EL_ZSTRING_IMPLEMENTATION, STRING_HANDLER} -- Internal attributes

	unencoded_area: SPECIAL [CHARACTER_32]

end