note
	description: "Class EL_ZSTRING (AKA ZSTRING) is a memory efficient alternative to using STRING_32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-26 9:12:18 GMT (Thursday 26th October 2017)"
	revision: "6"

class
	EL_ZSTRING

inherit
	EL_READABLE_ZSTRING
		export
			{ANY}
--			Element change
			append_all, append_all_general,
			append_boolean, append_character, append_double,
			append_integer_8, append_integer, append_integer_16, append_integer_64,
			append_natural_8, append_natural_16, append_natural_32, append_natural_64, append_real,
			append_unicode, append_string, append, append_string_general, append_substring, append_tuple_item, append_utf_8,
			extend, enclose, fill_character,
			precede, prepend_character, put_unicode, quote,
			translate, translate_general,
--			Conversion
			to_lower, to_proper_case, to_upper,
			unescape,
--			Removal
			keep_head, keep_tail, left_adjust, remove_head, remove_tail, right_adjust
		end

	STRING_GENERAL
		rename
			append as append_string_general,
			append_code as append_z_code,
			append_substring as append_substring_general,
			code as z_code,
			ends_with as ends_with_general,
			is_case_insensitive_equal as is_case_insensitive_equal_general,
			prepend as prepend_string_general,
			prepend_substring as prepend_substring_general,
			put_code as put_z_code,
			same_caseless_characters as same_caseless_characters_general,
			substring_index as substring_index_general,
			starts_with as starts_with_general
		undefine
			copy, hash_code, out, index_of, last_index_of, occurrences,
--			Status query
			ends_with_general, has,
			is_double, is_equal, is_integer, is_integer_32, is_real_64,
			same_characters, starts_with_general,
--			Conversion
			to_boolean, to_double, to_real_64, to_integer, to_integer_32,
			as_string_32, to_string_32, as_string_8, to_string_8, split,
--			Element change
			append_string_general
		redefine
--			Element change
			append_substring_general, prepend_string_general
		end

	INDEXABLE [CHARACTER_32, INTEGER]
		rename
			upper as count
		undefine
			copy, is_equal, out
		redefine
			changeable_comparison_criterion, prune_all
		end

	RESIZABLE [CHARACTER_32]
		undefine
			copy, is_equal, out
		redefine
			changeable_comparison_criterion
		end

create
	make, make_empty, make_from_string, make_from_general, make_from_utf_8, make_shared,
	make_from_other, make_filled, make_from_latin_1_c

convert
	make_from_general ({STRING_32, STRING}),

	to_unicode: {STRING_32}, to_latin_1: {STRING}

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

	plus alias "+" (s: READABLE_STRING_GENERAL): like Current
		do
			Result := new_string (count + s.count)
			Result.append (Current)
			Result.append_string_general (s)
		end

feature -- Basic operations

	do_with_splits (delimiter: READABLE_STRING_GENERAL; action: PROCEDURE [like Current])
		-- apply `action' for all delimited substrings
		local
			split_list: EL_SPLIT_ZSTRING_LIST
		do
			create split_list.make (Current, delimiter)
			split_list.do_all (action)
		end

feature -- Status query

	Changeable_comparison_criterion: BOOLEAN = False

	for_all_split (delimiter: READABLE_STRING_GENERAL; predicate: PREDICATE [like Current]): BOOLEAN
		-- `True' if all split substrings match `predicate'
		local
			split_list: EL_SPLIT_ZSTRING_LIST
		do
			create split_list.make (Current, delimiter)
			Result := split_list.for_all (predicate)
		end

	there_exists_split (delimiter: READABLE_STRING_GENERAL; predicate: PREDICATE [like Current]): BOOLEAN
		-- `True' if one split substring matches `predicate'
		local
			split_list: EL_SPLIT_ZSTRING_LIST
		do
			create split_list.make (Current, delimiter)
			Result := split_list.there_exists (predicate)
		end

feature -- Element change

	append_substring_general (s: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
		do
			append_substring (adapted_general (s, 1), start_index, end_index)
		end

	escape (escaper: EL_CHARACTER_ESCAPER [EL_ZSTRING])
		do
			make_from_other (escaper.escaped (Current))
		end

	insert_character (uc: CHARACTER_32; i: INTEGER)
		local
			c: CHARACTER
		do
			c := encoded_character (uc)
			internal_insert_character (c, i)
			shift_unencoded_from (i, 1)
			if c = Unencoded_character then
				put_unencoded_code (uc.natural_32_code, i)
			end
		ensure
			one_more_character: count = old count + 1
			inserted: item (i) = uc
			stable_before_i: elks_checking implies substring (1, i - 1) ~ (old substring (1, i - 1))
			stable_after_i: elks_checking implies substring (i + 1, count) ~ (old substring (i, count))
		end

	insert_string (s: EL_READABLE_ZSTRING; i: INTEGER)
		require
			valid_insertion_index: 1 <= i and i <= count + 1
		do
			internal_insert_string (s, i)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					shift_unencoded_from (i, s.count)
					insert_unencoded (s.shifted_unencoded (i - 1))

				when Only_current then
					shift_unencoded_from (i, s.count)

				when Only_other then
					set_unencoded_area (s.shifted_unencoded (i - 1).area)
			else
			end
		ensure
			valid_unencoded: is_unencoded_valid
			inserted: elks_checking implies (Current ~ (old substring (1, i - 1) + old (s.twin) + old substring (i, count)))
		end

	insert_string_general (s: READABLE_STRING_GENERAL; i: INTEGER)
		do
			insert_string (adapted_general (s, 1), i)
		end

	left_pad (uc: CHARACTER_32; a_count: INTEGER)
		do
			prepend_string (once_padding (uc, a_count))
		end

	prepend, prepend_string (s: EL_READABLE_ZSTRING)
		local
			new_unencoded, old_unencoded: like shifted_unencoded
		do
			internal_prepend (s)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					old_unencoded := shifted_unencoded (s.count)
					create new_unencoded.make_from_other (s)
					new_unencoded.append (old_unencoded)
					unencoded_area := new_unencoded.area
				when Only_current then
					shift_unencoded (s.count)
				when Only_other then
					unencoded_area := s.unencoded_area.twin
			else
			end
		ensure
			new_count: count = old (count + s.count)
			inserted: elks_checking implies same_string (old (s + Current))
		end

	prepend_string_general (str: READABLE_STRING_GENERAL)
		do
			prepend_string (adapted_general (str, 1))
		ensure then
			unencoded_valid: is_unencoded_valid
		end

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

	replace_character (uc_old, uc_new: CHARACTER_32)
		local
			code_old, code_new: NATURAL; c_i, c_old, c_new: CHARACTER; i, l_count: INTEGER; l_area: like area
		do
			code_old := uc_old.natural_32_code; code_new := uc_new.natural_32_code
			c_old := encoded_character (uc_old); c_new := encoded_character (uc_new)
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				c_i := l_area [i]
				if c_i = c_old and then (c_i = Unencoded_character implies code_old = unencoded_code (i + 1)) then
					l_area [i] := c_new
					if c_new = Unencoded_character then
						put_unencoded_code (code_new, i + 1)
					elseif c_i = Unencoded_character then
						remove_unencoded (i + 1, False)
					end
				end
				i := i + 1
			end
		end

	replace_delimited_substring (left, right, new: EL_READABLE_ZSTRING; include_delimiter: BOOLEAN; start_index: INTEGER)
			-- Searching from start_index, replaces text delimited by left and right with 'new'
			-- Text replaced includeds delimiter if 'include_delimiter' is true
		local
			pos_left, pos_right, start_pos, end_pos: INTEGER
		do
			pos_left := substring_index (left, start_index)
			if pos_left > 0 then
				start_pos := pos_left + left.count
				pos_right := substring_index (right, start_pos)
				if pos_right > 0 then
					end_pos := pos_right - 1
					if include_delimiter then
						start_pos := start_pos - left.count
						end_pos := end_pos + right.count
					end
					replace_substring (new, start_pos, end_pos)
				end
			end
		end

	replace_delimited_substring_general (
		left, right, new: READABLE_STRING_GENERAL; include_delimiter: BOOLEAN; start_index: INTEGER
	)
		do
			replace_delimited_substring (
				adapted_general (left, 1), adapted_general (right, 2), adapted_general (new, 3), include_delimiter, start_index
			)
		end

	replace_substring (s: EL_READABLE_ZSTRING; start_index, end_index: INTEGER)
		do
			internal_replace_substring (s, start_index, end_index)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					remove_unencoded_substring (start_index, end_index)
					shift_unencoded_from (start_index, s.count)
					insert_unencoded (s.shifted_unencoded (start_index - 1))

				when Only_current then
					remove_unencoded_substring (start_index, end_index)
					shift_unencoded_from (start_index, s.count)

				when Only_other then
					set_unencoded_area (s.shifted_unencoded (start_index - 1).area)
			else
			end
		ensure
			new_count: count = old count + old s.count - end_index + start_index - 1
			replaced: elks_checking implies (Current ~ (old (substring (1, start_index - 1) + s + substring (end_index + 1, count))))
			valid_unencoded: is_unencoded_valid
		end

	replace_substring_all (original, new: EL_READABLE_ZSTRING)
		local
			l_original, l_new: EL_ZSTRING_8_IMP; replace_not_done: BOOLEAN; positions: ARRAYED_LIST [INTEGER]
			size_difference, end_index, original_count, new_count: INTEGER
		do
			inspect respective_encoding (original)
				when Both_have_mixed_encoding, Only_current then
					replace_not_done := True
				when Only_other then
					-- Do nothing since original cannot match anything
				when Neither then
					if new.has_mixed_encoding then
						replace_not_done := True
					else
						-- Can use STRING_8 implemenation
						l_original := Once_zstring_8_array [1]; l_original.set_from_zstring (original)
						l_new := Once_zstring_8_array [2]; l_new.set_from_zstring (new)
						internal_replace_substring_all (l_original, l_new)
					end
			else
				replace_not_done := True
			end
			if replace_not_done and then not is_empty and then original /~ new then
				original_count := original.count
				positions := internal_substring_index_list (original)
				if not positions.is_empty then
					size_difference := new.count - original_count
					new_count := count + (new.count - original_count) * positions.count
					if new_count > count then
						resize (new_count)
					end
					from positions.start until positions.after loop
						positions.replace (positions.item + size_difference * (positions.index - 1))
						positions.forth
					end
					from positions.start until positions.after loop
						end_index := positions.item + original_count - 1
						replace_substring (new, positions.item, end_index)
						positions.forth
					end
				end
			end
		end

	replace_substring_general (s: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
		do
			replace_substring (adapted_general (s, 1), start_index, end_index)
		end

	replace_substring_general_all (original, new: READABLE_STRING_GENERAL)
		do
			replace_substring_all (adapted_general (original, 1), adapted_general (new, 2))
		end

	right_pad (uc: CHARACTER_32; a_count: INTEGER)
		do
			append_string (once_padding (uc, a_count))
		end

	substitute_tuple (inserts: TUPLE)
		do
			make_from_other (substituted_tuple (inserts))
		end

	translate_and_delete (old_characters, new_characters: EL_READABLE_ZSTRING)
		do
			translate_deleting_null_characters (old_characters, new_characters, True)
		end

	translate_deleting_null_characters (old_characters, new_characters: EL_READABLE_ZSTRING; delete_null: BOOLEAN)
			-- substitute characters occurring in `old_characters' with character
			-- at same position in `new_characters'. If `delete_null' is true, remove any characters
			-- corresponding to null value '%U'
		local
			i, j, index, l_count: INTEGER; old_z_code, new_z_code: NATURAL
			l_new_unencoded: like extendible_unencoded; l_unencoded: like unencoded_interval_index
			l_area, new_characters_area: like area; old_expanded, new_expanded: like as_expanded
		do
			l_area := area; new_characters_area := new_characters.area; l_count := count
			l_new_unencoded := extendible_unencoded; l_unencoded := unencoded_interval_index
			old_expanded := old_characters.as_expanded; new_expanded := new_characters.as_expanded_2
			from until i = l_count loop
				old_z_code := area_i_th_z_code (l_area, i)
				index := old_expanded.index_of (old_z_code.to_character_32, 1)
				if index > 0 then
					new_z_code := new_expanded.code (index)
				else
					new_z_code := old_z_code
				end
				if delete_null implies new_z_code > 0 then
					if new_z_code > 0xFF then
						l_new_unencoded.extend (z_code_to_unicode (new_z_code), j + 1)
						l_area.put (Unencoded_character, j)
					else
						l_area.put (new_z_code.to_character_8, j)
					end
					j := j + 1
				end
				i := i + 1
			end
			count := j
			l_area [j] := '%U'
			set_from_extendible_unencoded (l_new_unencoded)
			reset_hash
		end

feature -- Removal

	prune (uc: CHARACTER_32)
		local
			i: INTEGER
		do
			i := index_of (uc, 1)
			if i > 0 then
				remove (i)
			end
		end

	prune_all (uc: CHARACTER_32)
		local
			i, j, l_count: INTEGER; c, c_i: CHARACTER; l_unicode, unicode_i: NATURAL; l_area: like area
			l_new_unencoded: like extendible_unencoded; l_unencoded: like unencoded_interval_index
		do
			c := encoded_character (uc); l_unicode := uc.natural_32_code
			if has_mixed_encoding then
				l_area := area; l_count := count
				l_new_unencoded := extendible_unencoded; l_unencoded := unencoded_interval_index
				from  until i = l_count loop
					c_i := l_area.item (i)
					if c_i = Unencoded_character then
						unicode_i := l_unencoded.code (i + 1)
						if l_unicode /= unicode_i then
							l_area.put (c_i, j)
							l_new_unencoded.extend (unicode_i, j + 1)
							j := j + 1
						end
					elseif c_i /= c then
						l_area.put (c_i, j)
						j := j + 1
					end
					i := i + 1
				end
				count := j
				l_area [j] := '%U'
				set_from_extendible_unencoded (l_new_unencoded)
				reset_hash
			elseif c /= Unencoded_character then
				internal_prune_all (c)
			end
		ensure then
			valid_unencoded: is_unencoded_valid
			changed_count: count = (old count) - (old occurrences (uc))
		end

	prune_all_leading (uc: CHARACTER_32)
			-- Remove all leading occurrences of `c'.
		do
			remove_head (leading_occurrences (uc))
		end

	prune_all_trailing (uc: CHARACTER_32)
			-- Remove all trailing occurrences of `c'.
		do
			remove_tail (trailing_occurrences (uc))
		end

	remove (i: INTEGER)
		do
			internal_remove (i)
			remove_unencoded (i, True)
		ensure then
			valid_unencoded: is_unencoded_valid
		end

	remove_quotes
		require
			long_enough: count >= 2
		do
			remove_head (1); remove_tail (1)
		end

	remove_substring (start_index, end_index: INTEGER)
		do
			internal_remove_substring (start_index, end_index)
			remove_unencoded_substring (start_index, end_index)
		ensure
			valid_unencoded: is_unencoded_valid
			removed: elks_checking implies Current ~ (old substring (1, start_index - 1) + old substring (end_index + 1, count))
		end

	wipe_out
		do
			internal_wipe_out
			unencoded_area := Empty_unencoded
		end

feature {NONE} -- Implementation

	empty_escape_table: like Once_escape_table
		do
			Result := Once_escape_table
			Result.wipe_out
		end

	new_string (n: INTEGER): like Current
			-- New instance of current with space for at least `n' characters.
		do
			create Result.make (n)
		end

	once_padding (uc: CHARACTER_32; a_count: INTEGER): like empty_once_string
		local
			i, difference: INTEGER; pad_code: NATURAL
		do
			pad_code := unicode_to_z_code (uc)
			Result := empty_once_string
			difference := a_count - count
			from i := 1 until i > difference loop
				Result.append_z_code (pad_code)
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Once_escape_table: HASH_TABLE [NATURAL, NATURAL]
		once
			create Result.make (5)
		end
end
