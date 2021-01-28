note
	description: "[
		Core implementation of [$source EL_ZSTRING] using an 8 bit array to store characters encodeable
		by `codec', and a compacted array of 32-bit arrays to encode any character not defined by the 8-bit encoding.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-28 13:38:31 GMT (Thursday 28th January 2021)"
	revision: "17"

deferred class
	EL_ZSTRING_IMPLEMENTATION

inherit
	EL_SUBSTRING_32_ARRAY
		rename
			append as append_unencoded,
			append_list as append_unencoded_list,
			area as unencoded_area,
			character_count as unencoded_count,
			code as unencoded_code,
			count as unencoded_substring_count,
			count_greater_than_zero_flags as respective_encoding,
			hash_code as unencoded_hash_code,
			has as unencoded_has,
			index_of as unencoded_index_of,
			insert as insert_unencoded,
			is_valid as is_unencoded_valid,
			item as unencoded_item,
			joined as joined_substrings,
			last_index_of as unencoded_last_index_of,
			last_upper as unencoded_last_upper,
			make_empty as make_unencoded,
			make_filled as make_unencoded_filled,
			make_from_other as make_unencoded_from_other,
			not_empty as has_mixed_encoding,
			occurrences as unencoded_occurrences,
			overlaps as overlaps_unencoded,
			prepend as substrings_prepend,
			put_code as put_unencoded_code,
			remove as remove_unencoded,
			remove_substring as remove_unencoded_substring,
			same_string as same_unencoded_string,
			same_substring as same_unencoded_substring,
			set_area as set_unencoded_area,
			shift as shift_unencoded,
			shift_from as shift_unencoded_from,
			shifted as shifted_unencoded,
			substring_list as unencoded_substring_list,
			to_lower as unencoded_to_lower,
			to_upper as unencoded_to_upper,
			utf_8_byte_count as unencoded_utf_8_byte_count,
			valid_index as valid_substring_index,
			write as write_unencoded,
			z_code as unencoded_z_code
		undefine
			is_equal, copy, out
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
		end

	EL_SHARED_ZSTRING_CODEC

feature -- Access

	item alias "[]", at alias "@" (i: INTEGER): CHARACTER_32 assign put
			-- Unicode character at position `i'
		local
			c: CHARACTER
		do
			c := internal_item (i)
			if c = Unencoded_character then
				Result := unencoded_item (i)
			else
				Result := codec.as_unicode_character (c)
			end
		end

	unicode (i: INTEGER): NATURAL
		local
			c: CHARACTER
		do
			c := area [i - 1]
			if c = Unencoded_character then
				Result := unencoded_code (i)
			else
				Result := Codec.as_unicode_character (c).natural_32_code
			end
		end

	unicode_item (i: INTEGER): CHARACTER_32
		do
			Result := unicode (i).to_character_32
		end

feature -- Element change

	put (uc: CHARACTER_32; i: INTEGER)
			-- Replace character at position `i' by `uc'.
		do
			put_unicode (uc.natural_32_code, i)
		ensure then
			stable_count: count = old count
			stable_before_i: elks_checking implies substring (1, i - 1) ~ (old substring (1, i - 1))
			stable_after_i: elks_checking implies substring (i + 1, count) ~ (old substring (i + 1, count))
		end

	put_z_code (a_z_code: like z_code; i: INTEGER)
		do
			if a_z_code <= 0xFF then
				area [i - 1] := a_z_code.to_character_8
			else
				area [i - 1] := Unencoded_character
				put_unencoded_code (z_code_to_unicode (a_z_code), i)
			end
		end

feature -- Status query

	has (uc: CHARACTER_32): BOOLEAN
		-- `True' is string contains at least one `uc'?
		local
			c: CHARACTER
		do
			c := Codec.encoded_character (uc.natural_32_code)
			if c = Unencoded_character then
				Result := unencoded_has (uc.natural_32_code)
			else
				Result := internal_has (c)
			end
		end

	has_z_code (a_z_code: NATURAL): BOOLEAN
		do
			if a_z_code <= 0xFF then
				Result := internal_has (a_z_code.to_character_8)
			else
				Result := unencoded_has (z_code_to_unicode (a_z_code))
			end
		end

	is_ascii: BOOLEAN
		-- `True' if all characters in are in the range 0 to 127 and `has_mixed_encoding' is false
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			Result := not has_mixed_encoding and then c.is_ascii_area (area, area_lower, area_upper)
		end

feature {EL_READABLE_ZSTRING} -- Status query

	elks_checking: BOOLEAN
		deferred
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

feature {EL_READABLE_ZSTRING} -- Contract Support

	is_valid: BOOLEAN
			-- True if `unencoded_area' characters consistent with position and number of `Unencoded_character' in `area'
		local
			i, start_index, end_index, i_final: INTEGER
			l_unencoded: like unencoded_area; l_area: like area
		do
			if is_empty then
				Result := not has_mixed_encoding
			else
				if unencoded_last_upper <= count
					and then internal_occurrences (Unencoded_character) = unencoded_count
				then
					Result := True
				end
				if Result and then unencoded_substring_count > 0 then
					l_area := area; l_unencoded := unencoded_area; i_final := first_index (l_unencoded)
					from i := 1 until not Result or else i = i_final loop
						start_index := lower_bound (l_unencoded, i) - 1
						end_index := upper_bound (l_unencoded, i) - 1
						Result := l_area.filled_with (Unencoded_character, start_index, end_index)
						i := i + 2
					end
				end
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
		require
			valid_area_offset: a_unicode.count > 0 implies area.valid_index (a_unicode.count + area_offset - 1)
		local
			l_unencoded: like empty_once_unencoded
		do
			l_unencoded := empty_once_unencoded
			codec.encode (a_unicode, area, area_offset, l_unencoded)

			inspect respective_encoding (l_unencoded)
				when Both_have_mixed_encoding then
					append_unencoded_list (l_unencoded)
				when Only_other then
					set_from_list (l_unencoded)
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

	unencoded_indexable: EL_ZSTRING_INDEXABLE
		-- shared instance of `EL_ZSTRING_INDEXABLE' set to current string
		do
			Result := Once_indexable
			Result.start (unencoded_area)
		end

	put_unicode (a_code: NATURAL_32; i: INTEGER)
			-- put unicode at i th position
		require else -- from STRING_GENERAL
			valid_index: valid_index (i)
		local
			c, old_c: CHARACTER
		do
			old_c := area [i - 1]
			c := codec.encoded_character (a_code)
			area [i - 1] := c
			if c = Unencoded_character then
				put_unencoded_code (a_code, i)
			elseif old_c = Unencoded_character then
				remove_unencoded (i)
			end
			reset_hash
		ensure then
			inserted: unicode (i) = a_code
			stable_count: count = old count
			stable_before_i: Elks_checking implies substring (1, i - 1) ~ (old substring (1, i - 1))
			stable_after_i: Elks_checking implies substring (i + 1, count) ~ (old substring (i + 1, count))
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

	same_string (other: READABLE_STRING_GENERAL): BOOLEAN
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

	valid_index (i: INTEGER): BOOLEAN
		deferred
		end

feature {NONE} -- Constants

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

	Once_indexable: EL_ZSTRING_INDEXABLE
		once
			create Result
		end

	Tilde_code: NATURAL = 0x7E
		-- Point at which different Latin and Window character sets start to diverge
		-- (Apart from some control characters)

end