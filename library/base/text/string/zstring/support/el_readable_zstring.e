note
	description: "Read only interface to class [$source EL_ZSTRING]"
	test: "[$source ZSTRING_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-29 19:07:33 GMT (Sunday   29th   September   2019)"
	revision: "34"

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
--			Status query			
			is_double, is_real_64, is_integer, is_integer_32,
--			Conversion
			to_boolean, to_double, to_real_64, to_integer, to_integer_32
		redefine
--			Access
			hash_code, out, index_of, last_index_of, occurrences,
--			Status query
			ends_with_general, starts_with_general, has,
--			Comparison
			is_equal, same_characters,
--			Conversion
			split, as_string_32, to_string_32, as_string_8, to_string_8,
--			Duplication
			copy
		end

	EL_ZSTRING_IMPLEMENTATION
		rename
			append as internal_append,
			append_substring as internal_append_substring,
			ends_with as internal_ends_with,
			fill_character as internal_fill_character,
			has as internal_has,
			hash_code as area_hash_code,
			item as internal_item,
			index_of as internal_index_of,
			insert_character as internal_insert_character,
			insert_string as internal_insert_string,
			keep_head as internal_keep_head,
			keep_tail as internal_keep_tail,
			last_index_of as internal_last_index_of,
			linear_representation as internal_linear_representation,
			left_adjust as internal_left_adjust,
			make as internal_make,
			mirror as internal_mirror,
			occurrences as internal_occurrences,
			order_comparison as internal_order_comparison,
			prepend_character as internal_prepend_character,
			prepend as internal_prepend,
			prepend_substring as internal_prepend_substring,
			prune_all as internal_prune_all,
			remove as internal_remove,
			remove_substring as internal_remove_substring,
			replace_substring as internal_replace_substring,
			replace_substring_all as internal_replace_substring_all,
			same_characters as internal_same_characters,
			same_string as internal_same_string,
			share as internal_share,
			starts_with as internal_starts_with,
			string as internal_string,
			substring as internal_substring,
			right_adjust as internal_right_adjust,
			wipe_out as internal_wipe_out
		export
			{STRING_HANDLER} area, area_lower
		undefine
			copy, is_equal, out
		redefine
			make_from_string
		end

	EL_UNENCODED_CHARACTERS
		rename
			append as append_unencoded,
			area as unencoded_area,
			code as unencoded_code,
			count_greater_than_zero_flags as respective_encoding,
			grow as unencoded_grow,
			hash_code as unencoded_hash_code,
			has as unencoded_has,
			index_of as unencoded_index_of,
			interval_index as unencoded_interval_index,
			insert as insert_unencoded,
			item as unencoded_item,
			last_index_of as unencoded_last_index_of,
			make as make_unencoded,
			make_from_other as make_unencoded_from_other,
			not_empty as has_mixed_encoding,
			occurrences as unencoded_occurrences,
			overlaps as overlaps_unencoded,
			put_code as put_unencoded_code,
			remove as remove_unencoded,
			remove_substring as remove_unencoded_substring,
			same_string as same_unencoded_string,
			set_area as set_unencoded_area,
			set_from_extendible as set_from_extendible_unencoded,
			shift as shift_unencoded,
			shift_from as shift_unencoded_from,
			shifted as shifted_unencoded,
			substring as unencoded_substring,
			substring_list as unencoded_substring_list,
			sum_count as unencoded_count,
			to_lower as unencoded_to_lower,
			to_upper as unencoded_to_upper,
			utf_8_byte_count as unencoded_utf_8_byte_count,
			write as write_unencoded,
			z_code as unencoded_z_code
		export
			{EL_ZSTRING, EL_READABLE_ZSTRING} all
			{STRING_HANDLER}
				unencoded_z_code, set_unencoded_area, unencoded_interval_index, unencoded_area,
				extendible_unencoded, unencoded_count
			{ANY} has_mixed_encoding
		undefine
			is_equal, copy, out
		redefine
			is_unencoded_valid
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

	EL_SHARED_ZCODEC

	EL_SHARED_UTF_8_ZCODEC

	EL_SHARED_ONCE_STRINGS
		rename
			Once_string_8 as Shared_once_string_8
		end

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
		do
			make_from_general (create {STRING}.make_from_c (latin_1_ptr))
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

	index_of (uc: CHARACTER_32; start_index: INTEGER): INTEGER
		local
			c: CHARACTER
		do
			c := encoded_character (uc)
			if c = Unencoded_character then
				Result := unencoded_index_of (uc.natural_32_code, start_index)
			else
				Result := internal_index_of (c, start_index)
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
				Result := unencoded_index_of (z_code_to_unicode (a_z_code), start_index)
			end
		ensure then
			valid_result: Result = 0 or (start_index <= Result and Result <= count)
			zero_if_absent: (Result = 0) = not substring (start_index, count).has_z_code (a_z_code)
			found_if_present: substring (start_index, count).has_z_code (a_z_code) implies z_code (Result) = a_z_code
			none_before: substring (start_index, count).has_z_code (a_z_code) implies
				not substring (start_index, Result - 1).has_z_code (a_z_code)
		end

	item alias "[]", at alias "@" (i: INTEGER): CHARACTER_32
			-- Character at position `i'
		deferred
		end

	joined (a_list: FINITE [like Current]): ZSTRING
		-- `a_list' joined with `Current' as delimiter
		local
			list: LINEAR [like Current]
		do
			list := a_list.linear_representation
			create Result.make (sum_count (list) + (lines.count - 1) * count)
			from list.start until list.after loop
				if list.index > 1 then
					Result.append (Current)
				end
				Result.append_string_general (list.item)
				list.forth
			end
		end

	joined_general (a_list: FINITE [READABLE_STRING_GENERAL]): ZSTRING
		-- `a_list' joined with `Current' as delimiter
		local
			list: LINEAR [READABLE_STRING_GENERAL]
		do
			list := a_list.linear_representation
			create Result.make (sum_count (list) + (lines.count - 1) * count)
			from list.start until list.after loop
				if list.index > 1 then
					Result.append (Current)
				end
				Result.append_string_general (list.item)
				list.forth
			end
		end

	last_index_of (uc: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
			-- Position of last occurrence of `c',
			-- 0 if none.
		local
			c: CHARACTER
		do
			c := encoded_character (uc)
			if c = Unencoded_character then
				Result := unencoded_last_index_of (uc.natural_32_code, start_index_from_end)
			else
				Result := internal_last_index_of (c, start_index_from_end)
			end
		end

	multiplied (n: INTEGER): like Current
		do
			Result := twin
			Result.multiply (n)
		end

	share (other: like Current)
		do
			internal_share (other)
			unencoded_area := other.unencoded_area
		end

	split_intervals (delimiter: READABLE_STRING_GENERAL): EL_SEQUENTIAL_INTERVALS
			-- substring intervals of `Current' split with `delimiter'
		local
			intervals: like substring_intervals
			last_interval: INTEGER_64; l_last_upper: INTEGER
		do
			intervals := substring_intervals (delimiter)
			if intervals.is_empty then
				create Result.make (1)
				Result.extend (1, count)
			else
				create Result.make (intervals.count + 1)
				last_interval := Result.new_item (1, 0)
				from intervals.start until intervals.after loop
					Result.item_extend (intervals.between (last_interval))
					last_interval := intervals.item
					intervals.forth
				end
				l_last_upper := intervals.last_upper
				if l_last_upper < count then
					Result.extend (l_last_upper + 1, count)
				else
					Result.extend (count + 1, count)
				end
			end
		end

	substring_between (start_string, end_string: EL_READABLE_ZSTRING; start_index: INTEGER): like Current
			-- Returns string between substrings start_string and end_string from start_index.
			-- if end_string is empty or not found, returns the tail string starting from the character
			-- to the right of start_string. Returns empty string if start_string is not found.

			--	EXAMPLE:
			--			local
			--				log_line, ip_address: ASTRING
			--			do
			--				log_line := "Apr 13 05:34:49 myching sshd[7079]: Failed password for root from 43.255.191.152 port 55471 ssh2"
			--				ip_address := log_line.substring_between ("Failed password for root from ", " port")
			--				check
			--					correct_ip_address: ip_address.same_string ("43.255.191.152")
			--				end
			--			end
		local
			pos_start_string, pos_end_string: INTEGER
		do
			pos_start_string := substring_index (start_string, start_index)
			if pos_start_string > 0 then
				if end_string.is_empty then
					pos_end_string := count + 1
				else
					pos_end_string := substring_index (end_string, pos_start_string + start_string.count)
				end
				if pos_end_string > 0 then
					Result := substring (pos_start_string + start_string.count, pos_end_string - 1)
				else
					Result := substring (pos_start_string + start_string.count, count)
				end
			else
				Result := new_string (0)
			end
		end

	substring_between_general (start_string, end_string: READABLE_STRING_GENERAL; start_index: INTEGER): like Current
		do
			Result := substring_between (adapted_general (start_string, 1), adapted_general (end_string, 2), start_index)
		end

	substring_index (other: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		do
			inspect respective_encoding (other)
				when Both_have_mixed_encoding, Only_current, Neither then
					-- Make calls to `code' more efficient by caching calls to `unencoded_code' in expanded string
					Result := String_searcher.substring_index (Current, other.as_expanded, start_index, count)
				when Only_other then
					Result := 0
			else
			end
		end

	substring_index_general (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		do
			Result := substring_index (adapted_general (other, 1), start_index)
		end

	substring_index_in_bounds (other: EL_READABLE_ZSTRING; start_pos, end_pos: INTEGER): INTEGER
		do
			inspect respective_encoding (other)
				when Both_have_mixed_encoding, Only_current, Neither then
					-- Make calls to `code' more efficient by caching calls to `unencoded_code' in expanded string
					Result := String_searcher.substring_index (Current, other.as_expanded, start_pos, end_pos)
				when Only_other then
					Result := 0
			else
			end
		end

	substring_index_in_bounds_general (other: READABLE_STRING_GENERAL; start_pos, end_pos: INTEGER): INTEGER
		do
			Result := substring_index_in_bounds (adapted_general (other, 1), start_pos, end_pos)
		end

	substring_index_list (delimiter: EL_READABLE_ZSTRING): like internal_substring_index_list
		do
			Result := internal_substring_index_list (adapted_general (delimiter, 1)).twin
		end

	substring_intervals (str: READABLE_STRING_GENERAL): EL_SEQUENTIAL_INTERVALS
		local
			l_index_list: like internal_substring_index_list
			l_count, index: INTEGER
		do
			l_index_list := internal_substring_index_list (adapted_general (str, 1))
			create Result.make (l_index_list.count)
			l_count := str.count
			from l_index_list.start until l_index_list.after loop
				index := l_index_list.item
				Result.extend (index, index + l_count  - 1)
				l_index_list.forth
			end
		end

	unicode (i: INTEGER): NATURAL_32
		local
			c: CHARACTER
		do
			c := area [i - 1]
			if c = Unencoded_character then
				Result := unencoded_code (i)
			else
				Result := codec.as_unicode_character (c).natural_32_code
			end
		end

	unicode_item (i: INTEGER): CHARACTER_32
		do
			Result := unicode (i).to_character_32
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
			Result := word_index (adapted_general (word, 1), start_index)
		end

	z_code (i: INTEGER): NATURAL_32
			-- Returns hybrid code of latin and unicode
			-- Single byte codes are reserved for latin encoding.
			-- Unicode characters below 0xFF are shifted into the private use range 0xE000 .. 0xF8FF
			-- See https://en.wikipedia.org/wiki/Private_Use_Areas

			-- Implementation of {READABLE_STRING_GENERAL}.code
			-- Client classes include `EL_ZSTRING_SEARCHER'
		local
			c: CHARACTER
		do
			c := area [i - 1]
			if c = Unencoded_character then
				Result := unencoded_z_code (i)
			else
				Result := c.natural_32_code
			end
		ensure then
			first_byte_is_reserved_for_latin: area [i - 1] = Unencoded_character implies Result > 0xFF
		end

feature -- Constants

	Substitution_marker: EL_ZSTRING
		once
			Result := "%S"
		end

feature -- Output

	out: STRING
			-- Printable representation
		local
			c: CHARACTER; i: INTEGER; l_area: like area
		do
			create Result.make (count)
			l_area := area
			from i := 1 until i > count loop
				c := l_area [i - 1]
				if c = Unencoded_character then
					Result.extend ('?')
				else
					Result.extend (codec.as_unicode_character (c).to_character_8)
				end
				i := i + 1
			end
		end

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

feature -- Measurement

	Lower: INTEGER = 1

	leading_occurrences (uc: CHARACTER_32): INTEGER
			-- Returns count of continous occurrences of `uc' or white space starting from the begining
		local
			i, l_count: INTEGER; l_area: like area; c, c_i: CHARACTER; uc_code: NATURAL
		do
			c := encoded_character (uc); uc_code := uc.natural_32_code
			l_area := area; l_count := count
			if c = Unencoded_character then
				if has_mixed_encoding then
					from i := 0 until i = l_count loop
						c_i := l_area [i]
						if c_i = Unencoded_character and then unencoded_code (i + 1) = uc_code then
							Result := Result + 1
						else
							i := l_count - 1 -- break out of loop
						end
						i := i + 1
					end
				end
			else
				from i := 0 until i = l_count loop
					c_i := l_area [i]
					-- `Unencoded_character' is space
					if c_i = c then
						Result := Result + 1
					else
						i := l_count - 1 -- break out of loop
					end
					i := i + 1
				end
			end
		ensure
			substring_agrees: substring (1, Result).occurrences (uc) = Result
		end

	leading_white_space: INTEGER
		local
			i, l_count: INTEGER; l_area: like area; c_i: CHARACTER
			l_prop: like character_properties
		do
			l_area := area; l_count := count; l_prop := character_properties
			from i := 0 until i = l_count loop
				c_i := l_area [i]
				-- `Unencoded_character' is space
				if c_i = Unencoded_character then
					if l_prop.is_space (unencoded_item (i + 1)) then
						Result := Result + 1
					else
						i := l_count - 1 -- break out of loop
					end
				elseif c_i.is_space then
					Result := Result + 1
				else
					i := l_count - 1 -- break out of loop
				end
				i := i + 1
			end
		ensure
			substring_agrees: across substring (1, Result) as uc all character_properties.is_space (uc.item) end
		end

	occurrences (uc: CHARACTER_32): INTEGER
		local
			c: like area.item
		do
			c := encoded_character (uc)
			if c = Unencoded_character then
				Result := unencoded_occurrences (uc.natural_32_code)
			else
				Result := internal_occurrences (c)
			end
		end

	substitution_marker_count: INTEGER
		-- count of unescaped template substitution markers '%S' AKA '#'
		local
			l_index_list: like substring_index_list
			index: INTEGER; escape_code: NATURAL
		do
			l_index_list := substring_index_list (Substitution_marker)
			escape_code := ('%%').natural_32_code
			from l_index_list.start until l_index_list.after loop
				index := l_index_list.item
				if index > 1 and then z_code (index - 1) = escape_code then
					l_index_list.remove
				else
					l_index_list.forth
				end
			end
			Result := l_index_list.count
		end

	trailing_occurrences (uc: CHARACTER_32): INTEGER
			-- Returns count of continous occurrences of `uc' or white space starting from the end
		local
			i: INTEGER; l_area: like area; c, c_i: CHARACTER
			l_unencoded: like unencoded_interval_index; uc_code: NATURAL
		do
			c := encoded_character (uc); uc_code := uc.natural_32_code
			l_area := area; l_unencoded := unencoded_interval_index
			if c = Unencoded_character then
				if has_mixed_encoding then
					from i := count - 1 until i < 0 loop
						c_i := l_area [i]
						if c_i = Unencoded_character and then unencoded_code (i + 1) = uc_code then
							Result := Result + 1
						else
							i := 0 -- break out of loop
						end
						i := i - 1
					end
				end
			else
				from i := count - 1 until i < 0 loop
					c_i := l_area [i]
					-- `Unencoded_character' is space
					if c_i = c then
						Result := Result + 1
					else
						i := 0 -- break out of loop
					end
					i := i - 1
				end
			end
		ensure
			substring_agrees: substring (count - Result + 1, count).occurrences (uc) = Result
		end

	trailing_white_space: INTEGER
		local
			i: INTEGER; l_area: like area; c_i: CHARACTER
			l_unencoded: like unencoded_interval_index; l_prop: like character_properties
		do
			l_area := area; l_unencoded := unencoded_interval_index; l_prop := character_properties
			from i := count - 1 until i < 0 loop
				c_i := l_area [i]
				-- `Unencoded_character' is space
				if c_i = Unencoded_character then
					if l_prop.is_space (l_unencoded.code (i + 1).to_character_32) then
						Result := Result + 1
					else
						i := 0 -- break out of loop
					end
				elseif c_i.is_space then
					Result := Result + 1
				else
					i := 0 -- break out of loop
				end
				i := i - 1
			end
		ensure
			substring_agrees: across substring (count - Result + 1, count) as uc all character_properties.is_space (uc.item) end
		end

	utf_8_byte_count: INTEGER
		local
			i, l_count: INTEGER; l_area: like area; unencoded_found: BOOLEAN
		do
			l_count := count; l_area := area
			from i := 0 until i = l_count loop
				if l_area [i] = Unencoded_character then
					unencoded_found := True
				else
					Result := Result + 1
				end
				i := i + 1
			end
			if unencoded_found then
				Result := Result + unencoded_utf_8_byte_count
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
		require
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
				Result := unencoded_item (i).is_digit
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
			Result := enclosed_with (adapted_general (character_pair, 1))
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
			Result := ends_with (adapted_general (str, 1))
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

	has (uc: CHARACTER_32): BOOLEAN
			-- Does string include `uc'?
		local
			c: CHARACTER
		do
			c := codec.encoded_character (uc.natural_32_code)
			if c = Unencoded_character then
				Result := unencoded_has (uc.natural_32_code)
			else
				Result := internal_has (c)
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

	has_z_code (a_z_code: NATURAL): BOOLEAN
		do
			if a_z_code <= 0xFF then
				Result := internal_has (a_z_code.to_character_8)
			else
				Result := unencoded_has (z_code_to_unicode (a_z_code))
			end
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
					is_space := unencoded_item (i).is_space
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
						Result := Result and unencoded_item (i + 1).is_space
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
			Result := starts_with (adapted_general (str, 1))
		end

	valid_code (a_code: NATURAL_32): BOOLEAN
			-- Is `a_code' a valid code for a CHARACTER_32?
		do
			Result := True
		end

feature -- Conversion

	as_canonically_spaced: like Current
		do
			Result := twin
			Result.to_canonically_spaced
		end

	as_encoded_8 (a_codec: EL_ZCODEC): STRING
		local
			l_unencoded: like extendible_unencoded
			str_32: STRING_32
		do
			if codec.same_as (a_codec) then
				Result := to_latin_string_8
			elseif a_codec.is_latin_id (1) then
				Result := to_latin_1
			else
				str_32 := empty_once_string_32
				append_to_string_32 (str_32)
				create Result.make_filled ('%U', count)
				l_unencoded := extendible_unencoded
				a_codec.encode (str_32, Result.area, 0, l_unencoded)
			end
		ensure
			all_encoded: not Result.has (Unencoded_character)
		end

	as_lower: like Current
			-- New object with all letters in lower case.
		do
			Result := twin
			Result.to_lower
		end

	as_proper_case: like Current
		do
			Result := twin
			Result.to_proper_case
		end

	as_upper: like Current
			-- New object with all letters in upper case
		do
			Result := twin
			Result.to_upper
		end

	enclosed (left, right: CHARACTER_32): like Current
		do
			Result := twin
			Result.enclose (left, right)
		end

	escaped (escaper: EL_ZSTRING_ESCAPER): like Current
		do
			Result := escaper.escaped (Current, True)
		end

	linear_representation: LIST [CHARACTER_32]
		local
			l_count, i: INTEGER; c_i: CHARACTER
			l_area: like area; l_unencoded: like extendible_unencoded
			l_codec: like codec
		do
			l_unencoded := extendible_unencoded
			l_area := area; l_count := count; l_codec := codec
			create {ARRAYED_LIST [CHARACTER_32]} Result.make (l_count)
			from i := 0 until i = l_count loop
				c_i := l_area [i]
				if c_i = Unencoded_character then
					Result.extend (l_unencoded.item (i + 1))
				else
					Result.extend (l_codec.as_unicode_character (c_i))
				end
				i := i + 1
			end
		end

	lines: like split
		do
			Result := split ('%N')
		end

	mirror
			-- Reverse the order of characters.
			-- "Hello world" -> "dlrow olleH".
		local
			c_i: CHARACTER; i, l_count: INTEGER; l_area: like area
			l_unencoded: like extendible_unencoded
		do
			l_count := count
			if l_count > 1 then
				if has_mixed_encoding then
					l_area := area; l_unencoded := extendible_unencoded
					from i := l_count - 1 until i < 0 loop
						c_i := l_area.item (i)
						if c_i = Unencoded_character then
							l_unencoded.extend (unencoded_code (i + 1), l_count - i)
						end
						i := i - 1
					end
					internal_mirror
					set_unencoded_area (l_unencoded.area_copy)
				else
					internal_mirror
				end
				internal_hash_code := 0
			end
		ensure
			same_count: count = old count
			-- reversed: For every `i' in 1..`count', `item' (`i') = old `item' (`count'+1-`i')
		end

	mirrored: like Current
			-- Mirror image of string;
			-- Result for "Hello world" is "dlrow olleH".
		do
			Result := twin
			if count > 0 then
				Result.mirror
			end
		end

	quoted (type: INTEGER): like Current
		do
			Result := twin
			Result.quote (type)
		end

	split (a_separator: CHARACTER_32): LIST [like Current]
			-- Split on `a_separator'.
		local
			l_list: ARRAYED_LIST [like Current]; part: like Current; i, j, l_count, result_count: INTEGER
			separator: CHARACTER; call_index_of_8: BOOLEAN; separator_code: NATURAL
		do
			separator := encoded_character (a_separator)
			l_count := count
				-- Worse case allocation: every character is a separator
			if separator = Unencoded_character then
				separator_code := a_separator.natural_32_code
				result_count := unencoded_occurrences (separator_code) + 1
			else
				result_count := internal_occurrences (separator) + 1
				call_index_of_8 := True
			end
			create l_list.make (result_count)
			if l_count > 0 then
				if call_index_of_8 then
					from i := 1 until i > l_count loop
						j := internal_index_of (separator, i)
						if j = 0 then
								-- No separator was found, we will
								-- simply create a list with a copy of
								-- Current in it.
							j := l_count + 1
						end
						part := substring (i, j - 1)
						l_list.extend (part)
						i := j + 1
					end
				else
					from i := 1 until i > l_count loop
						j := unencoded_index_of (separator_code, i)
						if j = 0 then
							j := l_count + 1
						end
						part := substring (i, j - 1)
						l_list.extend (part)
						i := j + 1
					end
				end
				if j = l_count then
					check
						last_character_is_a_separator: item (j) = a_separator
					end
						-- A separator was found at the end of the string
					l_list.extend (new_string (0))
				end
			else
					-- Extend empty string, since Current is empty.
				l_list.extend (new_string (0))
			end
			Result := l_list
			check
				l_list.count = occurrences (a_separator) + 1
			end
		end

	stripped: like Current
		do
			Result := twin
			Result.left_adjust
			Result.right_adjust
		end

	substituted_tuple alias "#$" (inserts: TUPLE): like Current
			-- Returns string with all '%S' characters replaced with string from respective position in `inserts'
			-- Literal '%S' characters are escaped with the escape sequence "%%%S" i.e. (%#)
			-- Note that in Eiffel, '%S' is the same as the sharp sign '#'
		require
			enough_substitution_markers: substitution_marker_count >= inserts.count
		local
			l_index_list: like internal_substring_index_list
			marker_pos, index, previous_marker_pos: INTEGER
		do
			l_index_list := internal_substring_index_list (Substitution_marker)
			Result := new_string (count + tuple_as_string_count (inserts) - l_index_list.count)
			from l_index_list.start until l_index_list.after loop
				marker_pos := l_index_list.item
				if marker_pos - 1 > 0 and then item (marker_pos - 1) = '%%' then
					Result.append_substring (Current, previous_marker_pos + 1, marker_pos - 2)
					Result.append_character ('%S')
				else
					index := index + 1
					Result.append_substring (Current, previous_marker_pos + 1, marker_pos - 1)
					Result.append_tuple_item (inserts, index)
				end
				previous_marker_pos := marker_pos
				l_index_list.forth
			end
			Result.append_substring (Current, previous_marker_pos + 1, count)
		end

	substring_split (delimiter: EL_READABLE_ZSTRING): ARRAYED_LIST [like Current]
			-- split string on substring delimiter
		local
			intervals: like split_intervals
		do
			intervals := split_intervals (delimiter)
			create Result.make (intervals.count)
			from intervals.start until intervals.after loop
				Result.extend (substring (intervals.item_lower, intervals.item_upper))
				intervals.forth
			end
		end

	to_canonically_spaced
		-- adjust so that `is_canonically_spaced' becomes true
		local
			c_i: CHARACTER; i, l_count: INTEGER; l_area: like area
			is_space, is_space_state: BOOLEAN
			z_code_array: ARRAYED_LIST [NATURAL]; l_z_code: NATURAL
		do
			if not is_canonically_spaced then
				l_area := area; l_count := count
				create z_code_array.make (l_count)
				from i := 0 until i = l_count loop
					c_i := l_area [i]
					if c_i = Unencoded_character then
						is_space := unencoded_item (i + 1).is_space
						l_z_code := unencoded_z_code (i + 1)
					else
						is_space := c_i.is_space
						l_z_code := c_i.natural_32_code
					end
					if is_space_state then
						if not is_space then
							is_space_state := False
							z_code_array.extend (l_z_code)
						end
					elseif is_space then
						is_space_state := True
						z_code_array.extend (32)
					else
						z_code_array.extend (l_z_code)
					end
					i := i + 1
				end
				make (z_code_array.count)
				z_code_array.do_all (agent append_z_code)
			end
		ensure
			canonically_spaced: is_canonically_spaced
		end

	to_latin_string_8: STRING
			-- string with same encoding as `Codec'
		do
			create Result.make_filled (Unencoded_character, count)
			Result.area.copy_data (area, 0, 0, count)
		end

	to_string_32, as_string_32: STRING_32
			-- UCS-4
		do
			create Result.make (count)
			append_to_string_32 (Result)
		end

	to_string_8, to_latin_1, as_string_8: STRING
			-- encoded as ISO-8859-1
		local
			i, l_count: INTEGER; l_unicode: CHARACTER_32
			l_area: SPECIAL [CHARACTER_32]; l_result_area: like to_latin_1.area
			str_32: STRING_32
		do
			if Codec.is_latin_id (1) then
				Result := to_latin_string_8
			else
				l_count := count
				create Result.make_filled (Unencoded_character, l_count)
				str_32 := empty_once_string_32
				append_to_string_32 (str_32)
				l_area := str_32.area; l_result_area := Result.area
				from i := 0  until i = l_count loop
					l_unicode := l_area [i]
					if l_unicode.natural_32_code <= 0xFF then
						l_result_area [i] := l_unicode.to_character_8
					end
					i := i + 1
				end
			end
		end

	to_utf_8: STRING
		do
			create Result.make (count)
			append_to_utf_8 (Result)
		end

	to_unicode, to_general: READABLE_STRING_GENERAL
		local
			str_32: STRING_32
		do
			str_32 := empty_once_string_32
			append_to_string_32 (str_32)
			if str_32.is_valid_as_string_8 then
				Result := str_32.as_string_8
			else
				Result := str_32.twin
			end
		end

	translated (old_characters, new_characters: EL_READABLE_ZSTRING): like Current
		do
			Result := twin
			Result.translate (old_characters, new_characters)
		end

	translated_general (old_characters, new_characters: READABLE_STRING_GENERAL): like Current
		do
			Result := twin
			Result.translate_general (old_characters, new_characters)
		end

	unescaped (unescaper: EL_ZSTRING_UNESCAPER): like Current
		do
			create {ZSTRING} Result.make_unescaped (unescaper, Current)
		end

feature -- Duplication

	intervals_substring (intervals: like substring_intervals): like Current
		do
			if intervals.off then
				Result := new_string (0)
			else
				Result := substring (intervals.item_lower, intervals.item_upper)
			end
		end

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

	substring_end (start_index: INTEGER): like Current
		-- substring from `start_index' to `count'
		do
			Result := substring (start_index, count)
		end

	substring_start (end_index: INTEGER): like Current
		-- substring from 1 to `end_index'
		do
			Result := substring (1, end_index)
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
		do
			if attached {like Current} other as z_other then
				if has_mixed_encoding or else z_other.has_mixed_encoding then
					Result := same_unencoded_string (z_other)
									and then internal_same_characters (z_other, start_pos, end_pos, index_pos)
				else
					Result := internal_same_characters (z_other, start_pos, end_pos, index_pos)
				end
			else
				Result := Precursor (other, start_pos, end_pos, index_pos)
			end
		end

feature {EL_READABLE_ZSTRING} -- Removal

	keep_head (n: INTEGER)
			-- Remove all characters except for the first `n';
			-- do nothing if `n' >= `count'.
		local
			old_count: INTEGER
		do
			old_count := count
			internal_keep_head (n)
			if n < old_count and then has_mixed_encoding then
				set_from_extendible_unencoded (unencoded_substring (1, n))
			end
		ensure then
			valid_unencoded: is_unencoded_valid
		end

	keep_tail (n: INTEGER)
			-- Remove all characters except for the last `n';
			-- do nothing if `n' >= `count'.
		local
			old_count: INTEGER
		do
			old_count := count
			internal_keep_tail (n)
			if n < old_count and then has_mixed_encoding then
				set_from_extendible_unencoded (unencoded_substring (old_count - n + 1, old_count))
			end
		ensure then
			valid_unencoded: is_unencoded_valid
		end

	remove_head (n: INTEGER)
			-- Remove first `n' characters;
			-- if `n' > `count', remove all.
		require
			n_non_negative: n >= 0
		do
			if n > count then
				count := 0
				internal_hash_code := 0
			else
				keep_tail (count - n)
			end
		ensure
			removed: elks_checking implies Current ~ (old substring (n.min (count) + 1, count))
		end

	remove_tail (n: INTEGER)
			-- Remove last `n' characters;
			-- if `n' > `count', remove all.
		require
			n_non_negative: n >= 0
		local
			l_count: INTEGER
		do
			l_count := count
			if n > l_count then
				count := 0
				internal_hash_code := 0
			else
				keep_head (l_count - n)
			end
		ensure
			removed: elks_checking implies Current ~ (old substring (1, count - n.min (count)))
		end

	unescape (unescaper: EL_ZSTRING_UNESCAPER)
		do
			make_from_other (unescaped (unescaper))
		end

feature {EL_READABLE_ZSTRING} -- Element change

	append_all (a_list: FINITE [like Current])
		local
			list: LINEAR [like Current]
		do
			list := a_list.linear_representation
			grow (count + sum_count (list))
			from list.start until list.after loop
				append (list.item)
				list.forth
			end
		end

	append_all_general (a_list: INDEXABLE [READABLE_STRING_GENERAL, INTEGER])
		local
			list: LINEAR [READABLE_STRING_GENERAL]
		do
			list := a_list.linear_representation
			grow (count + sum_count (list))
			from list.start until list.after loop
				append_string_general (list.item)
				list.forth
			end
		end

	append_character, extend (uc: CHARACTER_32)
		do
			append_unicode (uc.natural_32_code)
		end

	append_character_8 (uc: CHARACTER_8)
		do
			append_unicode (uc.natural_32_code)
		end

	append_string, append (s: EL_READABLE_ZSTRING)
		local
			old_count: INTEGER
		do
			if s.has_mixed_encoding then
				old_count := count
				internal_append (s)
				append_unencoded (s.shifted_unencoded (old_count))
			else
				internal_append (s)
			end
		ensure
			new_count: count = old (count + s.count)
			inserted: elks_checking implies same_string (old (Current + s))
		end

	append_string_general (str: READABLE_STRING_GENERAL)
		local
			old_count: INTEGER
		do
			if attached {EL_ZSTRING} str as str_z then
				append_string (str_z)
			else
				old_count := count
				grow (old_count + str.count)
				set_count (old_count + str.count)
				encode (str, old_count)
				reset_hash
			end
		ensure then
			unencoded_valid: is_unencoded_valid
		end

	append_substring (s: EL_READABLE_ZSTRING; start_index, end_index: INTEGER)
		local
			old_count: INTEGER; l_unencoded: like unencoded_substring
		do
			old_count := count
			internal_append_substring (s, start_index, end_index)
			if s.has_mixed_encoding then
				l_unencoded := s.unencoded_substring (start_index, end_index)
				if l_unencoded.not_empty then
					l_unencoded.shift (old_count)
					append_unencoded (l_unencoded)
				end
			end
		ensure
			new_count: count = old count + (end_index - start_index + 1)
			appended: elks_checking implies same_string (old (Current + s.substring (start_index, end_index)))
		end

	append_tuple_item (tuple: TUPLE; i: INTEGER)
		local
			l_reference: ANY
		do
			inspect tuple.item_code (i)
				when {TUPLE}.Boolean_code then
					append_boolean (tuple.boolean_item (i))

				when {TUPLE}.Character_8_code then
					append_character (tuple.character_8_item (i))

				when {TUPLE}.Character_32_code then
					append_character (tuple.character_32_item (i))

				when {TUPLE}.Integer_16_code then
					append_integer_16 (tuple.integer_16_item (i))

				when {TUPLE}.Integer_32_code then
					append_integer (tuple.integer_item (i))

				when {TUPLE}.Integer_64_code then
					append_integer_64 (tuple.integer_64_item (i))

				when {TUPLE}.Natural_16_code then
					append_integer_16 (tuple.integer_16_item (i))

				when {TUPLE}.Natural_32_code then
					append_natural_32 (tuple.natural_32_item (i))

				when {TUPLE}.Natural_64_code then
					append_natural_64 (tuple.natural_64_item (i))

				when {TUPLE}.Pointer_code then
					append_string_general (tuple.pointer_item (i).out)

				when {TUPLE}.Real_32_code then
					append_real (tuple.real_32_item (i))

				when {TUPLE}.Real_64_code then
					append_double (tuple.real_64_item (i))

				when {TUPLE}.Reference_code then
					l_reference := tuple.reference_item (i)
					if attached {READABLE_STRING_GENERAL} l_reference as string then
						append_string_general (string)
					elseif attached {EL_PATH} l_reference as l_path then
						append_string (l_path.to_string)
					elseif attached {PATH} l_reference as path then
						append_string_general (path.name)
					else
						append_string_general (l_reference.out)
					end
			else
			end
		end

	append_unicode (uc: like unicode)
			-- Append `uc' at end.
			-- It would be nice to make this routine over ride 'append_code' but unfortunately
			-- the post condition links it to 'code' and for performance reasons it is undesirable to have
			-- code return unicode.
		local
			l_count: INTEGER
		do
			l_count := count + 1
			if l_count > capacity then
				resize (l_count)
			end
			set_count (l_count)
			put_unicode (uc, l_count)
		ensure then
			item_inserted: unicode (count) = uc
			new_count: count = old count + 1
			stable_before: elks_checking implies substring (1, count - 1) ~ (old twin)
		end

	append_utf_8 (a_utf_8: READABLE_STRING_8)
		do
			if attached {STRING} a_utf_8 as utf_8 then
				append_string_general (Utf_8_codec.as_unicode (utf_8, False))
			end
		end

	append_z_code (c: like z_code)
		deferred
		end

	enclose (left, right: CHARACTER_32)
		do
			grow (count + 2); prepend_character (left); append_character (right)
		end

	fill_character (uc: CHARACTER_32)
		local
			c: CHARACTER
		do
			c := encoded_character (uc)
			if c = Unencoded_character then
			else
				internal_fill_character (c)
			end
		end

	multiply (n: INTEGER)
			-- Duplicate a string within itself
			-- ("hello").multiply(3) => "hellohellohello"
		require
			meaningful_multiplier: n >= 1
		local
			i, old_count: INTEGER
		do
			old_count := count
			grow (n * count)
			from i := n until i = 1 loop
				append_substring (Current, 1, old_count)
				i := i - 1
			end
		end

	precede, prepend_character (uc: CHARACTER_32)
		local
			c: CHARACTER
		do
			c := encoded_character (uc)
			internal_prepend_character (c)
			shift_unencoded (1)
			if c = Unencoded_character then
				put_unencoded_code (uc.natural_32_code, 1)
			end
		end

	prepend_substring (s: EL_READABLE_ZSTRING; start_index, end_index: INTEGER)
		local
			old_count: INTEGER; l_unencoded: like unencoded_substring
		do
			old_count := count
			internal_prepend_substring (s, start_index, end_index)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					shift_unencoded (end_index - start_index + 1)
					l_unencoded := s.unencoded_substring (start_index, end_index)
					if l_unencoded.not_empty then
						l_unencoded.append (Current)
						unencoded_area := l_unencoded.area_copy
					end
				when Only_current then
					shift_unencoded (end_index - start_index + 1)
				when Only_other then
					l_unencoded := s.unencoded_substring (start_index, end_index)
					if l_unencoded.not_empty then
						unencoded_area := l_unencoded.area_copy
					end
			else
			end
		ensure
			new_count: count = old count + (end_index - start_index + 1)
			appended: elks_checking implies same_string (old (s.substring (start_index, end_index) + Current))
		end

	put_unicode (a_code: NATURAL_32; i: INTEGER)
			-- put unicode at i th position
		require -- from STRING_GENERAL
			valid_index: valid_index (i)
		local
			c: CHARACTER
		do
			c := codec.encoded_character (a_code)
			area [i - 1] := c
			if c = Unencoded_character then
				put_unencoded_code (a_code, i)
			end
			internal_hash_code := 0
		ensure
			inserted: unicode (i) = a_code
			stable_count: count = old count
			stable_before_i: Elks_checking implies substring (1, i - 1) ~ (old substring (1, i - 1))
			stable_after_i: Elks_checking implies substring (i + 1, count) ~ (old substring (i + 1, count))
		end

	quote (type: INTEGER)
		require
			type_is_single_or_double: type = 1 or type = 2
		local
			c: CHARACTER_32
		do
			if type = 1 then
				 c := '%''
			else
				 c := '"'
			end
			enclose (c, c)
		end

	to_lower
			-- Convert to lower case.
		do
			to_lower_area (area, 0, count - 1)
			unencoded_to_lower
			internal_hash_code := 0
		ensure
			length_and_content: elks_checking implies Current ~ (old as_lower)
		end

	to_proper_case
		local
			i, l_count: INTEGER; state_alpha: BOOLEAN
			l_area: like area
		do
			to_lower
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				if state_alpha then
					if not is_area_alpha_item (l_area, i) then
						state_alpha := False
					end
				else
					if is_area_alpha_item (l_area, i) then
						state_alpha := True
						to_upper_area (l_area, i, i)
					end
				end
				i := i + 1
			end
		end

	to_upper
			-- Convert to upper case.
		do
			to_upper_area (area, 0, count - 1)
			unencoded_to_upper
			internal_hash_code := 0
		ensure
			length_and_content: elks_checking implies Current ~ (old as_upper)
		end

	translate (old_characters, new_characters: EL_READABLE_ZSTRING)
		do
			translate_deleting_null_characters (old_characters, new_characters, False)
		end

	translate_deleting_null_characters (old_characters, new_characters: EL_READABLE_ZSTRING; delete_null: BOOLEAN)
		require
			each_old_has_new: old_characters.count = new_characters.count
		deferred
		ensure
			valid_unencoded: is_unencoded_valid
			unchanged_count: not delete_null implies count = old count
			changed_count: delete_null implies count = old (count - deleted_count (old_characters, new_characters))
		end

	translate_general (old_characters, new_characters: READABLE_STRING_GENERAL)
		do
			translate (adapted_general (old_characters, 1), adapted_general (new_characters, 2))
		end

feature {EL_READABLE_ZSTRING} -- Removal

	left_adjust
			-- Remove leading whitespace.
		do
			if is_left_adjustable then
				if has_mixed_encoding then
					remove_head (leading_white_space)
				else
					internal_left_adjust
				end
			end
		end

	right_adjust
			-- Remove trailing whitespace.
		do
			if is_right_adjustable then
				if has_mixed_encoding then
					remove_tail (trailing_white_space)
				else
					internal_right_adjust
				end
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

feature {EL_READABLE_ZSTRING} -- Contract Support

	deleted_count (old_characters, new_characters: EL_READABLE_ZSTRING): INTEGER
		local
			i: INTEGER
		do
			across to_string_32 as uc loop
				i := old_characters.index_of (uc.item, 1)
				if i > 0 and then new_characters.z_code (i) = 0 then
					Result := Result + 1
				end
			end
		end

	is_unencoded_valid: BOOLEAN
			-- True if `unencoded_area' characters consistent with position and number of `Unencoded_character' in `area'
		local
			i, j, l_lower, l_upper, l_count, l_sum_count, array_count: INTEGER
			l_unencoded: like unencoded_area; l_area: like area
		do
			l_area := area; l_unencoded := unencoded_area; array_count := l_unencoded.count
			Result := True
			if array_count > 0 then
				from i := 0 until not Result or else  i = array_count loop
					l_lower := l_unencoded.item (i).to_integer_32; l_upper := l_unencoded.item (i + 1).to_integer_32
					l_count := l_upper - l_lower + 1
					from j := l_lower until not Result or else j > l_upper loop
						Result := Result and l_area [j - 1] = Unencoded_character
						j := j + 1
					end
					l_sum_count := l_sum_count + l_count
					i := i + l_count + 2
				end
				Result := Result and internal_occurrences (Unencoded_character) = l_sum_count
			end
		end

feature {EL_READABLE_ZSTRING, STRING_HANDLER} -- Access

	area_i_th_z_code (a_area: like area; i: INTEGER): NATURAL
		local
			c_i: CHARACTER
		do
			c_i := a_area [i]
			if c_i = Unencoded_character then
				Result := unencoded_z_code (i + 1)
			else
				Result := c_i.natural_32_code
			end
		end

	as_expanded: STRING_32
			-- Current expanded as `z_code' sequence
		do
			Result := Once_expanded_strings [0]; Result.wipe_out
			fill_expanded (Result)
		end

	as_expanded_2: STRING_32
			-- Current expanded as `z_code' sequence
		do
			Result := Once_expanded_strings [1]; Result.wipe_out
			fill_expanded (Result)
		end

feature -- Basic operation

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
			old_count: INTEGER
		do
			old_count := output.count
			output.grow (old_count + count)
			output.set_count (old_count + count)
			output.area [old_count + count] := '%U'
			codec.decode (count, area, output.area, old_count)
			write_unencoded (output, old_count)
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
			Utf_8_codec.write_string_to_utf_8 (Current, utf_8_out)
		end

feature {NONE} -- Implementation

	adapted_general (a_general: READABLE_STRING_GENERAL; argument_number: INTEGER): like Current
		do
			if attached {EL_READABLE_ZSTRING} a_general as zstring then
				Result := zstring
			elseif argument_number = 1 then
				Result := Empty_once_string
				Result.append_string_general (a_general)
			else
				Result := new_string (a_general.count)
				Result.append_string_general (a_general)
			end
		end

	encode (a_unicode: READABLE_STRING_GENERAL; area_offset: INTEGER)
		require
			valid_area_offset: a_unicode.count > 0 implies area.valid_index (a_unicode.count + area_offset - 1)
		local
			l_unencoded: like extendible_unencoded
		do
			l_unencoded := extendible_unencoded
			codec.encode (a_unicode, area, area_offset, l_unencoded)

			inspect respective_encoding (l_unencoded)
				when Both_have_mixed_encoding then
					append_unencoded (l_unencoded)
				when Only_other then
					unencoded_area := l_unencoded.area_copy
			else
			end
		end

	encoded_character (uc: CHARACTER_32): CHARACTER
		do
			if uc.natural_32_code <= Tilde_code then
				Result := uc.to_character_8
			else
				Result := codec.encoded_character (uc.natural_32_code)
			end
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

	is_area_alpha_item (a_area: like area; i: INTEGER): BOOLEAN
		local
			c: CHARACTER
		do
			c := a_area [i]
			if c = Unencoded_character then
				Result := unencoded_item (i + 1).is_alpha
			else
				Result := Codec.is_alpha (c.natural_32_code)
			end
		end

	natural_64_width (natural_64: NATURAL_64): INTEGER
		local
			quotient: NATURAL_64
		do
			if natural_64 = 0 then
				Result := 1
			else
				from quotient := natural_64 until quotient = 0 loop
					Result := Result + 1
					quotient := quotient // 10
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

	same_unencoded_substring (other: EL_READABLE_ZSTRING; start_index: INTEGER): BOOLEAN
			-- True if characters in `other' are unencoded at the same
			-- positions as `Current' starting at `start_index'
		require
			valid_start_index: start_index + other.count - 1 <= count
		local
			i, l_count: INTEGER; l_area: like area; c_i: CHARACTER
			unencoded_other: like unencoded_interval_index
		do
			Result := True
			l_area := area; l_count := other.count
			unencoded_other := other.unencoded_interval_index
			from i := 0 until i = l_count or else not Result loop
				c_i := l_area [i + start_index - 1]
				check
					same_unencoded_positions: c_i = Unencoded_character implies c_i = other.area [i]
				end
				if c_i = Unencoded_character then
					Result := Result and unencoded_code (start_index + i) = unencoded_other.code (i + 1)
				end
				i := i + 1
			end
		end

	sum_count (list: LINEAR [READABLE_STRING_GENERAL]): INTEGER
		do
			from list.start until list.after loop
				Result := Result + list.item.count
				list.forth
			end
		end

	to_lower_area (a: like area; start_index, end_index: INTEGER)
			-- Replace all characters in `a' between `start_index' and `end_index'
			-- with their lower version when available.
		do
			codec.to_lower (a, start_index, end_index, Current)
		end

	to_upper_area (a: like area; start_index, end_index: INTEGER)
			-- Replace all characters in `a' between `start_index' and `end_index'
			-- with their upper version when available.
		do
			codec.to_upper (a, start_index, end_index, Current)
		end

	tuple_as_string_count (tuple: TUPLE): INTEGER
		local
			l_count, i: INTEGER; l_reference: ANY
		do
			from i := 1 until i > tuple.count loop
				inspect tuple.item_code (i)
					when {TUPLE}.Boolean_code then
						l_count := 4
					when {TUPLE}.Character_code then
						l_count := 1
					when {TUPLE}.Integer_16_code then
						l_count := natural_64_width (tuple.integer_16_item (i).abs.to_natural_64)

					when {TUPLE}.Integer_32_code then
						l_count := natural_64_width (tuple.integer_32_item (i).abs.to_natural_64)

					when {TUPLE}.Integer_64_code then
						l_count := natural_64_width (tuple.integer_64_item (i).abs.to_natural_64)

					when {TUPLE}.Natural_16_code then
						l_count := natural_64_width (tuple.natural_16_item (i).to_natural_64)

					when {TUPLE}.Natural_32_code then
						l_count := natural_64_width (tuple.natural_32_item (i).to_natural_64)

					when {TUPLE}.Natural_64_code then
						l_count := natural_64_width (tuple.natural_64_item (i))

					when {TUPLE}.Pointer_code then
						l_count := 9

					when {TUPLE}.Reference_code then
						l_reference := tuple.reference_item (i)
						if attached {READABLE_STRING_GENERAL} l_reference as str then
							l_count := str.count
						elseif attached {EL_PATH} l_reference as path then
							l_count := path.parent_path.count + path.base.count + 1
						end

				else -- Double or real or something else
					l_count := 7
				end
				Result := Result + l_count
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Unicode_property: CHARACTER_PROPERTY
			-- Property for Unicode characters.
		once
			create Result.make
		end

	Once_expanded_strings: SPECIAL [STRING_32]
		once
			create Result.make_empty (2)
			from  until Result.count = 2 loop
				Result.extend (create {STRING_32}.make_empty)
			end
		end

	Once_substring_indices: ARRAYED_LIST [INTEGER]
		do
			create Result.make (5)
		end

	String_searcher: EL_ZSTRING_SEARCHER
		once
			create Result.make
		end

	Tilde_code: NATURAL = 0x7E
		-- Point at which different Latin and Window character sets start to diverge
		-- (Apart from some control characters)

end
