note
	description: "[
		Implementation base of ${ZSTRING} using an 8 bit array to store characters encodeable
		by `codec', and a compacted array of 32-bit arrays to encode any character not defined by the 8-bit encoding.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-03 12:32:44 GMT (Saturday 3rd May 2025)"
	revision: "123"

deferred class
	EL_ZSTRING_BASE

inherit
	EL_COMPACT_SUBSTRINGS_32_I
		rename
			append as append_unencoded,
			append_intervals as append_unencoded_intervals,
			area as unencoded_area,
			buffer as unencoded_buffer,
			code as unencoded_code,
			combined_area as unencoded_combined_area,
			count_greater_than_zero_flags as respective_encoding,
			empty_buffer as empty_unencoded_buffer,
			fill as unencoded_fill,
			fill_list as unencoded_fill_list,
			first_lower as unencoded_first_lower,
			first_upper as unencoded_first_upper,
			extended_hash_code as unencoded_hash_code_to,
			has as unencoded_has,
			has_between as unencoded_has_between,
			index_of as unencoded_index_of,
			interval_sequence as unencoded_interval_sequence,
			insert as insert_unencoded,
			intersects as has_unencoded_between,
			item as unencoded_item,
			i_th_substring as unencoded_i_th_substring,
			interval_count as unencoded_interval_count,
			last_index_of as unencoded_last_index_of,
			last_upper as unencoded_last_upper,
			make as make_unencoded,
			make_filled as make_unencoded_filled,
			make_from_other as make_unencoded_from_other,
			minimal_increase as minimal_unencoded_increase,
			new_filled_area as new_filled_unencoded_area,
			not_empty as has_mixed_encoding,
			occurrences as unencoded_occurrences,
			overlaps as overlaps_unencoded,
			put as put_unencoded,
			put_lower as put_unencoded_lower,
			put_upper as put_unencoded_upper,
			remove as remove_unencoded,
			remove_substring as remove_unencoded_substring,
			replace_character as replace_unencoded_character,
			same_characters as same_unencoded_characters,
			same_string as same_unencoded_string,
			set_area as set_unencoded_area,
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
		end

	EL_ZSTRING_CHARACTER_8_BASE
		rename
			fill_character as internal_fill_character,
			hash_code as area_hash_code,
			item as internal_item,
			index_of as internal_index_of,
			insert_string as internal_insert_string,
			keep_head as internal_keep_head,
			keep_tail as internal_keep_tail,
			last_index_of as internal_last_index_of,
			make as internal_make,
			order_comparison as internal_order_comparison,
			remove as internal_remove,
			same_characters as internal_same_characters,
			same_string as internal_same_string,
			share as internal_share,
			string as internal_string,
			substring as internal_substring,
			wipe_out as internal_wipe_out
		export
			{STRING_HANDLER} area, area_lower
		end

	EL_READABLE_ZSTRING_I

	EL_INDEXABLE_FROM_1

	EL_SHARED_ESCAPE_TABLE; EL_SHARED_IMMUTABLE_8_MANAGER

feature -- Access

	item alias "[]", at alias "@" (i: INTEGER): CHARACTER_32 assign put
		-- Unicode character at position `i'
		local
			c_i: CHARACTER
		do
			c_i := area [i - 1]
			inspect character_8_band (c_i)
				when Substitute then
					Result := unencoded_code (i).to_character_32

				when Ascii_range then
					Result := c_i.to_character_32
			else
				Result := Unicode_table [c_i.code]
			end
		end

	item_8 (i: INTEGER): CHARACTER_8
		-- internal character at position `i'
		do
			Result := area [i - 1]
		end

	item_code (i: INTEGER): INTEGER
		obsolete
			"Due to potential truncation it is recommended to use `code (i)' instead."
		do
			Result := item (i).natural_32_code.to_integer_32
		end

	unicode (i: INTEGER): NATURAL
		local
			c_i: CHARACTER
		do
			c_i := area [i - 1]
			inspect character_8_band (c_i)
				when Substitute then
					Result := unencoded_code (i)

				when Ascii_range then
					Result := c_i.natural_32_code
			else
				Result := Unicode_table [c_i.code].natural_32_code
			end
		end

feature -- Element change

	put (uc: CHARACTER_32; i: INTEGER)
			-- Replace character at position `i' by `uc'.
		require else -- from STRING_GENERAL
			valid_index: valid_index (i)
		local
			old_c: CHARACTER
		do
			if attached area as c then
				old_c := c [i - 1]
				c [i - 1] := Codec.encoded_character (uc)
				inspect c [i - 1]
					when Substitute then
						put_unencoded (uc, i)
				else
					if old_c = Substitute then
						remove_unencoded (i)
					end
				end
				reset_hash
			end
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
		do
			if attached area as c then
				if a_z_code > 0xFF then
					c [i - 1] := Substitute
					put_unencoded (z_code_to_unicode (a_z_code).to_character_32, i)
				else
					inspect c [i - 1]
						when Substitute then
							remove_unencoded (i)
					else
					end
					c [i - 1] := a_z_code.to_character_8
				end
			end
		end

feature -- Status query

	has (uc: CHARACTER_32): BOOLEAN
		-- `True' is string contains at least one `uc'?
		local
			c: CHARACTER
		do
			inspect uc.code
			-- allow uc = 26 to map to unicode subtitute character
				when 0 .. 25, 27 .. Max_ascii_code then
					Result := has_character_8 (area, uc.to_character_8, count - 1)
			else
				c := Codec.encoded_character (uc)
				inspect c
					when Substitute then
						Result := unencoded_has (uc)
				else
					Result := has_character_8 (area, c, count - 1)
				end
			end
		end

	has_z_code (a_z_code: NATURAL): BOOLEAN
		do
			if a_z_code < 0x100 then
				Result := String_8.has (Current, a_z_code.to_character_8)
			else
				Result := unencoded_has (z_code_to_unicode (a_z_code).to_character_32)
			end
		end

	is_alpha_numeric: BOOLEAN
		local
			c_i: CHARACTER; i, i_final: INTEGER
		do
			if attached area as c then
				i_final := count - 1
				from i := 0; Result := True until not Result or i > i_final loop
					c_i := c [i]
					inspect character_8_band (c_i)
						when Substitute then
							Result := unencoded_item (i + 1).is_alpha_numeric

						when Ascii_range then
							Result := c_i.is_alpha_numeric
					else
						Result := Codec.is_alphanumeric (c_i.natural_32_code)
					end
					i := i + 1
				end
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
			-- True position and number of `Substitute' in `area' consistent with `unencoded_area' substrings
		local
			i, j, lower, upper, l_count, interval_count, sum_count: INTEGER
		do
			if has_mixed_encoding then
				l_count := count
				if attached area as l_area and then attached unencoded_area as area_32 then
					Result := True
					from i := 0 until not Result or else i = area_32.count loop
						lower := area_32 [i].code; upper := area_32 [i + 1].code
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
				end
				Result := Result and String_8.occurrences (Current, Substitute) = sum_count
			else
				Result := String_8.occurrences (Current, Substitute) = 0
			end
		end

	shared_substring (start_index, end_index: INTEGER): EL_READABLE_ZSTRING
		-- `Current' if `start_index = 1' and `end_index = count'
		do
			if start_index = 1 and then end_index = count then
			else
				Result := substring (start_index, end_index)
			end
		end

feature {EL_ZSTRING_BASE} -- Status query

	elks_checking: BOOLEAN
		deferred
		end

	has_character_8 (a_area: like area; c: CHARACTER_8; upper_index: INTEGER): BOOLEAN
		local
			i: INTEGER
		do
			from until Result or else i > upper_index loop
				Result := a_area [i] = c
				i := i + 1
			end
		end

	has_substitutes_between (a_area: like area; start_index, end_index: INTEGER): BOOLEAN
		local
			i, i_upper: INTEGER
		do
			i_upper := end_index - 1
			from i := start_index - 1 until i > i_upper loop
				inspect a_area [i]
					when Substitute then
						Result := True
						i := i_upper + 1 -- break
				else
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	adapted_argument (general: READABLE_STRING_GENERAL; index: INTEGER): EL_ZSTRING
		do
			Result := adapted_argument_for_type (general, string_storage_type (general), index)
		end

	adapted_argument_for_type (general: READABLE_STRING_GENERAL; type_code: CHARACTER; index: INTEGER): EL_ZSTRING
		require
			valid_type_code: valid_string_storage_type (type_code)
			valid_index: 1 <= index and index <= Once_adapted_argument.count
		do
			inspect type_code
				when 'X' then
					if attached {ZSTRING} general as z_str then
						Result := z_str
					end

			else
				inspect index
					when 1 .. 3 then
						Result := Once_adapted_argument [index - 1]
						Result.wipe_out
				else
					create Result.make (general.count)
				end
				Result.append_string_general_for_type (general, type_code)
			end
		end

	encode (general: READABLE_STRING_GENERAL; area_offset: INTEGER)
		do
			encode_substring (general, 1, general.count, area_offset)
		end

	encode_substring (general: READABLE_STRING_GENERAL; start_index, end_index, area_offset: INTEGER)
		require
			valid_area_offset: valid_area_offset (general, start_index, end_index, area_offset)
		do
			if attached Once_interval_list.emptied as unencoded_intervals then
				codec.encode_substring_general (general, area, start_index, end_index, area_offset, unencoded_intervals)

				if unencoded_intervals.count > 0 and attached super_readable_general (general) as str then
					if has_mixed_encoding then
						append_unencoded_intervals (str, unencoded_intervals, area_offset - start_index + 1)
					else
						make_from_intervals (str, unencoded_intervals, area_offset - start_index + 1)
					end
				end
			end
		end

	encoded_character (uc: CHARACTER_32): CHARACTER
		do
			if uc.code <= Max_ascii_code then
				Result := uc.to_character_8
			else
				Result := codec.encoded_character (uc)
			end
		end

	leading_ascii_count (a_area: SPECIAL [CHARACTER]; start_index, end_index: INTEGER): INTEGER
		require
			valid_order: start_index <= end_index + 1
			valid_start_index: start_index <= end_index implies a_area.valid_index (start_index)
			valid_end_index: start_index <= end_index implies a_area.valid_index (end_index)
		local
			i: INTEGER; non_ascii: BOOLEAN; c_i: CHARACTER
		do
			from i := start_index until non_ascii or else i > end_index loop
				c_i := a_area [i]
				inspect character_8_band (c_i)
					when Substitute then
						non_ascii := True

					when Ascii_range then
						Result := Result + 1
						i := i + 1
				else
					non_ascii := True
				end
			end
		end

	put_unicode (a_code: NATURAL_32; i: INTEGER)
			-- put unicode at i th position
		do
			put (a_code.to_character_32, i)
		end

	compatible_string_8 (general: READABLE_STRING_GENERAL): detachable READABLE_STRING_8
		require
			is_string_8: general.is_string_8
		do
			Result := compatible_substring_8 (general, 1, general.count)
		end

	compatible_substring_8 (
		general: READABLE_STRING_GENERAL; start_index, end_index: INTEGER

	): detachable READABLE_STRING_8
		-- `general' cast to type `READABLE_STRING_8' if all characters are unchanged for
		-- `Codec' encoding. `Void' if any character has a different encoding
		require
			is_string_8: general.is_string_8
		local
			i_lower, i_upper, index_lower: INTEGER
		do
			if general.is_immutable then
				if attached {READABLE_STRING_8} general as readable_8
					and then attached Character_area_8.get_lower (readable_8, $index_lower) as l_area
				then
					i_lower := index_lower + start_index - 1
					i_upper := i_lower + end_index - start_index
					if Codec.is_compatible_string_8 (l_area, i_lower, i_upper) then
						Result := readable_8
					end
				end

			elseif attached {STRING_8} general as str_8
				and then Codec.is_compatible_string_8 (str_8.area, start_index - 1, end_index - 1)
			then
				Result := str_8
			end
		end

	to_lower_area (a: like area; start_index, end_index: INTEGER)
		-- Replace all characters in `a' between `start_index' and `end_index'
		-- with their lower version when available.
		do
			codec.to_lower (a, start_index, end_index, Current)
		end

	to_proper_area (a: like area; start_index, end_index: INTEGER)
		-- Replace all characters in `a' between `start_index' and `end_index'
		-- with their propercase version when available.
		do
			codec.to_proper (a, start_index, end_index, Current)
		end

	to_upper_area (a: like area; start_index, end_index: INTEGER)
		-- Replace all characters in `a' between `start_index' and `end_index'
		-- with their upper version when available.
		do
			codec.to_upper (a, start_index, end_index, Current)
		end

	valid_area_offset (general: READABLE_STRING_GENERAL; start_index, end_index, area_offset: INTEGER): BOOLEAN
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
			inspect c
				when Substitute then
					Result := unencoded_z_code (i)
			else
				Result := c.natural_32_code
			end
		ensure then
			first_byte_is_reserved_for_latin: area [i - 1] = Substitute implies Result > 0xFF
			reversible: Codec.z_code_as_unicode (Result) = unicode (i)
		end

feature {NONE} -- Constants

	Once_adapted_argument: SPECIAL [ZSTRING]
		once
			create Result.make_filled (create {ZSTRING}.make_empty, 3)
			Result [1] := create {ZSTRING}.make_empty
			Result [2] := create {ZSTRING}.make_empty
		end

	Once_escape_table: EL_HASH_TABLE [NATURAL, NATURAL]
		once
			create Result.make (5)
		end

	Once_interval_list: EL_ARRAYED_INTERVAL_LIST
		once
			create Result.make_empty
		end

	Once_split_intervals: EL_ZSTRING_SPLIT_INTERVALS
		once
			create Result.make_empty
		end

	Once_substring_indices: EL_ARRAYED_LIST [INTEGER]
		do
			create Result.make (5)
		end

	Substitution_mark_unescaper: EL_ZSTRING_UNESCAPER
		once
			create Result.make (Escape_table.Substitution)
		end

end