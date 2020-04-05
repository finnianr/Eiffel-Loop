note
	description: "[
		Aspect of [$source EL_ZSTRING] that supports unicode encoding of characters not supported
		in the 8-bit encoding of [$source EL_ZSTRING_CHARACTER_8_IMPLEMENTATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-05 15:42:38 GMT (Sunday 5th April 2020)"
	revision: "1"

deferred class
	EL_ZSTRING_UNICODE_IMPLEMENTATION

inherit
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
			last_upper as unencoded_last_upper,
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
		undefine
			is_equal, copy, out
		redefine
			is_unencoded_valid
		end

	EL_SHARED_ZCODEC

	STRING_HANDLER
		undefine
			is_equal, copy, out
		end

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
				Result := codec.as_unicode_character (c).natural_32_code
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

feature {EL_READABLE_ZSTRING} -- Contract Support

	is_unencoded_valid: BOOLEAN
			-- True if `unencoded_area' characters consistent with position and number of `Unencoded_character' in `area'
		local
			i, j, l_lower, l_upper, l_count, l_sum_count, array_count: INTEGER
			l_unencoded: like unencoded_area; l_area: like area
		do
			if is_empty then
				Result := not has_mixed_encoding
			else
				l_area := area; l_unencoded := unencoded_area; array_count := l_unencoded.count
				Result := unencoded_last_upper <= count
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

	put_unicode (a_code: NATURAL_32; i: INTEGER)
			-- put unicode at i th position
		require else -- from STRING_GENERAL
			valid_index: valid_index (i)
		local
			c: CHARACTER
		do
			c := codec.encoded_character (a_code)
			area [i - 1] := c
			if c = Unencoded_character then
				put_unencoded_code (a_code, i)
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

	capacity: INTEGER
			-- Allocated space
		deferred
		end

	character_properties: CHARACTER_PROPERTY
		deferred
		end

	count: INTEGER
		-- Actual number of characters making up the string
		deferred
		end

	current_readable: EL_READABLE_ZSTRING
		deferred
		end

	grow (newsize: INTEGER)
		deferred
		end

	leading_white_space: INTEGER
		deferred
		end

	make (n: INTEGER)
		-- Allocate space for at least `n' characters.
		deferred
		end

	make_from_other (other: EL_READABLE_ZSTRING)
		deferred
		end

	reset_hash
		deferred
		end

	resize (newsize: INTEGER)
		deferred
		end

	same_string (other: READABLE_STRING_GENERAL): BOOLEAN
		deferred
		end

	set_count (number: INTEGER)
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

	unescaped (unescaper: EL_ZSTRING_UNESCAPER): EL_READABLE_ZSTRING
		deferred
		end

	valid_index (i: INTEGER): BOOLEAN
		deferred
		end

feature {NONE} -- 8 bit routines

	area: SPECIAL [CHARACTER_8]
			-- Storage for characters.
		deferred
		end

	internal_append_tuple_item (tuple: TUPLE; i: INTEGER)
		deferred
		end

	internal_fill_character (c: CHARACTER_8)
		deferred
		end

	internal_item (i: INTEGER): CHARACTER_8
		deferred
		end

	internal_occurrences (c: CHARACTER_8): INTEGER
		deferred
		end

feature {NONE} -- Constants

	Once_adapted_argument: SPECIAL [ZSTRING]
		once
			create Result.make_filled (create {ZSTRING}.make_empty, 3)
			Result [1] := create {ZSTRING}.make_empty
			Result [2] := create {ZSTRING}.make_empty
		end

	Tilde_code: NATURAL = 0x7E
		-- Point at which different Latin and Window character sets start to diverge
		-- (Apart from some control characters)

end
