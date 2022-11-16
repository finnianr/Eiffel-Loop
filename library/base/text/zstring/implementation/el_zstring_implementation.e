note
	description: "[
		Core implementation of [$source ZSTRING] using an 8 bit array to store characters encodeable
		by `codec', and a compacted array of 32-bit arrays to encode any character not defined by the 8-bit encoding.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "38"

deferred class
	EL_ZSTRING_IMPLEMENTATION

inherit
	EL_UNENCODED_CHARACTERS
		rename
			append as append_unencoded,
			area as unencoded_area,
			buffer as unencoded_buffer,
			code as unencoded_code,
			count_greater_than_zero_flags as respective_encoding,
			empty_buffer as empty_unencoded_buffer,
			hash_code as unencoded_hash_code,
			has as unencoded_has,
			index_of as unencoded_index_of,
			interval_index_other as unencoded_indexable_other,
			interval_index as unencoded_indexable,
			insert as insert_unencoded,
			intersects as has_unencoded_between,
			item as unencoded_item,
			last_index_of as unencoded_last_index_of,
			last_upper as unencoded_last_upper,
			make as make_unencoded,
			make_filled as make_unencoded_filled,
			make_from_other as make_unencoded_from_other,
			minimal_increase as minimal_area_increase,
			not_empty as has_mixed_encoding,
			occurrences as unencoded_occurrences,
			overlaps as overlaps_unencoded,
			put as put_unencoded,
			remove as remove_unencoded,
			remove_substring as remove_unencoded_substring,
			replace_character as replace_unencoded_character,
			same_string as same_unencoded_string,
			set_from_buffer as set_unencoded_from_buffer,
			shift as shift_unencoded,
			shift_from as shift_unencoded_from,
			shifted as shifted_unencoded,
			substring_list as unencoded_substring_list,
			character_count as unencoded_count,
			to_lower as unencoded_to_lower,
			to_upper as unencoded_to_upper,
			utf_8_byte_count as unencoded_utf_8_byte_count,
			write as write_unencoded,
			z_code as unencoded_z_code,
			is_valid as is_unencoded_valid
		undefine
			is_equal, copy, out
		redefine
			has_unencoded_between
		end

	EL_ZSTRING_CHARACTER_8_IMPLEMENTATION
		rename
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
			prune_all as internal_prune_all,
			remove as internal_remove,
			remove_substring as internal_remove_substring,
			replace_substring as internal_replace_substring,
			replace_substring_all as internal_replace_substring_all,
			same_caseless_characters as internal_same_caseless_characters,
			same_characters as internal_same_characters,
			same_string as internal_same_string,
			share as internal_share,
			starts_with as internal_starts_with,
			string as internal_string,
			split as internal_split,
			substring as internal_substring,
			substring_index as internal_substring_index,
			substring_index_in_bounds as internal_substring_index_in_bounds,
			right_adjust as internal_right_adjust,
			wipe_out as internal_wipe_out
		export
			{STRING_HANDLER} area, area_lower
		undefine
			copy, is_equal, out
		end

	EL_SHARED_ZSTRING_CODEC

feature -- Access

	item alias "[]", at alias "@" (i: INTEGER): CHARACTER_32 assign put
		-- Unicode character at position `i'
		local
			code: INTEGER
		do
			code := area [i - 1].code
			if code = Substitute_code then
				Result := unencoded_code (i).to_character_32
			elseif code <= Max_7_bit_code then
				Result := code.to_character_32
			else
				Result := Unicode_table [code]
			end
		end

	item_code (i: INTEGER): INTEGER
		obsolete
			"Due to potential truncation it is recommended to use `code (i)' instead."
		do
			Result := item (i).natural_32_code.to_integer_32
		end

	unicode (i: INTEGER): NATURAL
		local
			code: INTEGER
		do
			code := area [i - 1].code
			if code = Substitute_code then
				Result := unencoded_code (i)
			elseif code <= Max_7_bit_code then
				Result := code.to_natural_32
			else
				Result := Unicode_table [code].to_character_32.natural_32_code
			end
		end

feature -- Element change

	put (uc: CHARACTER_32; i: INTEGER)
			-- Replace character at position `i' by `uc'.
		require else -- from STRING_GENERAL
			valid_index: valid_index (i)
		local
			c, old_c: CHARACTER
		do
			old_c := area [i - 1]
			c := Codec.encoded_character (uc)
			area [i - 1] := c
			if c = Substitute then
				put_unencoded (uc, i)
			elseif old_c = Substitute then
				remove_unencoded (i)
			end
			reset_hash
		ensure then
			inserted: item (i) = uc
			stable_count: count = old count
			stable_before_i: Elks_checking implies substring (1, i - 1) ~ (old substring (1, i - 1))
			stable_after_i: Elks_checking implies substring (i + 1, count) ~ (old substring (i + 1, count))
		end

	put_z_code (a_z_code: like z_code; i: INTEGER)

		-- Passes over 3000 millisecs (in descending order)
		-- append_zcode     :  7979.3 times (100%)
		-- append_character :  7924.4 times (-0.7%)
		local
			c_i: CHARACTER
		do
			if a_z_code <= 0xFF then
				c_i := area [i - 1]
				area [i - 1] := a_z_code.to_character_8
				if c_i = Substitute then
					remove_unencoded (i + 1)
				end
			else
				area [i - 1] := Substitute
				put_unencoded (z_code_to_unicode (a_z_code).to_character_32, i)
			end
		end

feature -- Status query

	has (uc: CHARACTER_32): BOOLEAN
		-- `True' is string contains at least one `uc'?
		local
			c: CHARACTER
		do
			if uc.code <= Max_7_bit_code then
				c := uc.to_character_8
			else
				c := Codec.encoded_character (uc)
			end
			if c = Substitute then
				Result := unencoded_has (uc)
			else
				Result := internal_has (c)
			end
		end

	has_z_code (a_z_code: NATURAL): BOOLEAN
		do
			if a_z_code <= 0xFF then
				Result := internal_has (a_z_code.to_character_8)
			else
				Result := unencoded_has (z_code_to_unicode (a_z_code).to_character_32)
			end
		end

	is_ascii: BOOLEAN
		-- `True' if all characters in are in the range 0 to 127 and `has_mixed_encoding' is false
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			Result := not has_mixed_encoding and then c.is_ascii_area (area, area_lower, area_upper)
		end

	valid_index (i: INTEGER): BOOLEAN
		deferred
		end

feature -- Contract Support

	is_valid: BOOLEAN
			-- True position and number of `Unencoded_character' in `area' consistent with `unencoded_area' substrings
		local
			i, j, lower, upper, l_count, interval_count, sum_count, i_final: INTEGER
			l_unencoded: like unencoded_area; l_area: like area
		do
			if has_mixed_encoding then
				l_count := count
				l_area := area; l_unencoded := unencoded_area; i_final := l_unencoded.count
				Result := True
				from i := 0 until not Result or else i = i_final loop
					lower := lower_bound (l_unencoded, i); upper := upper_bound (l_unencoded, i)
					interval_count := upper - lower + 1
					if upper <= l_count then
						from j := lower until not Result or else j > upper loop
							Result := Result and l_area [j - 1] = Substitute
							j := j + 1
						end
					else
						Result := False
					end
					sum_count := sum_count + interval_count
					i := i + interval_count + 2
				end
				Result := Result and internal_occurrences (Substitute) = sum_count
			else
				Result := internal_occurrences (Substitute) = 0
			end
		end

feature {EL_ZSTRING_IMPLEMENTATION} -- Status query

	elks_checking: BOOLEAN
		deferred
		end

	has_unencoded_between (start_index, end_index: INTEGER): BOOLEAN
		local
			i, i_final: INTEGER; l_area: like area
		do
			-- check which might be quicker: look for `Unencoded_character' or iterate `unencoded_area'
			-- (assume average of 5 characters per interval, weighted in favor of `area' search)
			if (end_index - start_index) < (unencoded_area.count // 7) * 3 then
				l_area := area; i_final := end_index.min (count)
				from i := start_index - 1 until Result or else i = i_final loop
					Result := l_area [i] = Substitute
					i := i + 1
				end
			else
				Result := Precursor (start_index, end_index)
			end
		end

	is_area_alpha_item (a_area: like area; i: INTEGER): BOOLEAN
		local
			c: CHARACTER
		do
			c := a_area [i]
			if c = Substitute then
				Result := unencoded_item (i + 1).is_alpha
			else
				Result := Codec.is_alpha (c.natural_32_code)
			end
		end

	is_canonically_spaced: BOOLEAN
		deferred
		end

	is_empty: BOOLEAN
			-- Is structure empty?
		deferred
		end

	is_left_adjustable: BOOLEAN
		deferred
		end

	is_right_adjustable: BOOLEAN
		deferred
		end

	same_unencoded_substring (other: EL_READABLE_ZSTRING; start_index: INTEGER): BOOLEAN
		-- True if characters in `other' are unencoded at the same
		-- positions as `Current' starting at `start_index'
		require
			valid_start_index: start_index + other.count - 1 <= count
		local
			i, i_final: INTEGER; l_area: like area; c_i: CHARACTER
			unencoded, unencoded_other: like unencoded_indexable
		do
			Result := True
			l_area := area; i_final := other.count
			unencoded := unencoded_indexable; unencoded_other := other.unencoded_indexable_other
			from i := 0 until i = i_final or else not Result loop
				c_i := l_area [i + start_index - 1]
				check
					same_unencoded_positions: c_i = Substitute implies c_i = other.area [i]
				end
				if c_i = Substitute then
					Result := Result and unencoded.code (start_index + i) = unencoded_other.code (i + 1)
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	adapted_argument (a_general: READABLE_STRING_GENERAL; index: INTEGER): EL_ZSTRING
		require
			valid_index: 1 <= index and index <= Once_adapted_argument.count
		do
			if attached {EL_ZSTRING} a_general as zstring then
				Result := zstring
			else
				inspect index
					when 1 .. 3 then
						Result := Once_adapted_argument [index - 1]
						Result.wipe_out
				else
					create Result.make (a_general.count)
				end
				Result.append_string_general (a_general)
			end
		end

	encode (a_unicode: READABLE_STRING_GENERAL; area_offset: INTEGER)
		do
			encode_substring (a_unicode, 1, a_unicode.count, area_offset)
		end

	encode_substring (a_unicode: READABLE_STRING_GENERAL; start_index, end_index, area_offset: INTEGER)
		require
			valid_area_offset: valid_area_offset (a_unicode, start_index, end_index, area_offset)
		local
			buffer: like empty_unencoded_buffer
		do
			buffer := empty_unencoded_buffer
			codec.encode_substring (a_unicode, area, start_index, end_index, area_offset, buffer)

			inspect respective_encoding (buffer)
				when Both_have_mixed_encoding then
					append_unencoded (buffer, 0)
				when Only_other then
					set_unencoded_from_buffer (buffer)
			else
			end
		end

	encoded_character (uc: CHARACTER_32): CHARACTER
		do
			if uc.code <= Max_7_bit_code then
				Result := uc.to_character_8
			else
				Result := codec.encoded_character (uc)
			end
		end

	item_8 (i: INTEGER): CHARACTER_8
		-- internal character at position `i'
		do
			Result := area [i - 1]
		end

	put_unicode (a_code: NATURAL_32; i: INTEGER)
			-- put unicode at i th position
		do
			put (a_code.to_character_32, i)
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

	valid_area_offset (a_unicode: READABLE_STRING_GENERAL; start_index, end_index, area_offset: INTEGER): BOOLEAN
		local
			l_count: INTEGER
		do
			l_count := end_index - start_index + 1
			Result := l_count > 0 implies area.valid_index (l_count + area_offset - 1)
		end

	z_code (i: INTEGER): NATURAL_32
			-- Returns hybrid code of latin and unicode
			-- Single byte codes are reserved for latin encoding.
			-- Unicode characters below 0xFF have bit number 31 set to 1 using `Sign_bit' so
			-- that any zcode <= 0xFF can be assumed to be an encoded character using some codec.

			-- Implementation of {READABLE_STRING_GENERAL}.code
			-- Client classes include `EL_ZSTRING_SEARCHER'
		local
			c: CHARACTER
		do
			c := area [i - 1]
			if c = Substitute then
				Result := unencoded_z_code (i)
--			elseif c <= '%/0xFF/' then
--				Result := Sign_bit & c.natural_32_code
			else
				Result := c.natural_32_code
			end
		ensure then
			first_byte_is_reserved_for_latin: area [i - 1] = Substitute implies Result > 0xFF
			reversible: z_code_to_unicode (Result) = unicode (i)
		end

feature {EL_READABLE_ZSTRING} -- Deferred Implementation

	append_z_code (c: NATURAL)
		deferred
		end

	as_lower: like Current
		deferred
		end

	as_upper: like Current
		deferred
		end

	character_properties: CHARACTER_PROPERTY
		deferred
		end

	current_readable: EL_READABLE_ZSTRING
		deferred
		end

	leading_white_space: INTEGER
		deferred
		end

	make (n: INTEGER)
		-- Allocate space for at least `n' characters.
		deferred
		end

	make_from_other (other: EL_CONVERTABLE_ZSTRING)
		deferred
		end

	make_from_zcode_area (zcode_area: SPECIAL [NATURAL])
		deferred
		end

	reset_hash
		deferred
		end

	same_string (other: READABLE_STRING_32): BOOLEAN
		deferred
		end

	substring (start_index, end_index: INTEGER): EL_READABLE_ZSTRING
		deferred
		end

	to_string_32: STRING_32
		deferred
		end

	trailing_white_space: INTEGER
		deferred
		end

	unescaped (unescaper: EL_ZSTRING_UNESCAPER): EL_CONVERTABLE_ZSTRING
		deferred
		end

feature {NONE} -- Constants

	Buffer_32: EL_STRING_32_BUFFER
		once
			create Result
		end

	Latin_1_codec: EL_ZCODEC
		once
			Result := Codec_factory.codec_by ({EL_ENCODING_CONSTANTS}.Latin_1)
		end

	Once_adapted_argument: SPECIAL [ZSTRING]
		once
			create Result.make_filled (create {ZSTRING}.make_empty, 3)
			Result [1] := create {ZSTRING}.make_empty
			Result [2] := create {ZSTRING}.make_empty
		end

	Once_substring_indices: ARRAYED_LIST [INTEGER]
		do
			create Result.make (5)
		end

end