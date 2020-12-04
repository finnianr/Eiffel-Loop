note
	description: "Implementation routines to transform instance of [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-03 11:12:08 GMT (Thursday 3rd December 2020)"
	revision: "4"

deferred class
	EL_TRANSFORMABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_APPENDABLE_ZSTRING

	EL_MODULE_CHAR_32

feature {EL_READABLE_ZSTRING} -- Basic operations

	enclose (left, right: CHARACTER_32)
		do
			grow (count + 2); prepend_character (left); append_character (right)
		end

	fill_character (uc: CHARACTER_32)
			-- Fill with `capacity' characters all equal to `uc'.
		local
			c: CHARACTER
		do
			c := encoded_character (uc)
			if c = Unencoded_character then
			else
				internal_fill_character (c)
			end
		end

	mirror
			-- Reverse the order of characters.
			-- "Hello world" -> "dlrow olleH".
		local
			c_i: CHARACTER; i, l_count: INTEGER; l_area: like area
			l_unencoded: like empty_once_unencoded
		do
			l_count := count
			if l_count > 1 then
				if has_mixed_encoding then
					l_area := area; l_unencoded := empty_once_unencoded
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
				reset_hash
			end
		ensure
			same_count: count = old count
			-- reversed: For every `i' in 1..`count', `item' (`i') = old `item' (`count'+1-`i')
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
				append_substring (current_readable, 1, old_count)
				i := i - 1
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
						is_space := Char_32.is_space (unencoded_item (i + 1)) -- Work around for finalization bug
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
			reset_hash
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
			reset_hash
		ensure
			length_and_content: elks_checking implies Current ~ (old as_upper)
		end

	translate (old_characters, new_characters: EL_READABLE_ZSTRING)
		do
			translate_deleting_null_characters (old_characters, new_characters, False)
		end

	translate_deleting_null_characters (old_characters, new_characters: EL_READABLE_ZSTRING; delete_null: BOOLEAN)
			-- substitute characters occurring in `old_characters' with character
			-- at same position in `new_characters'. If `delete_null' is true, remove any characters
			-- corresponding to null value '%U'
		require
			each_old_has_new: old_characters.count = new_characters.count
		local
			i, j, index, l_count: INTEGER; old_z_code, new_z_code: NATURAL
			l_new_unencoded: EL_EXTENDABLE_UNENCODED_CHARACTERS; l_unencoded: EL_UNENCODED_CHARACTERS_INDEX
			l_area, new_characters_area: like area; old_expanded, new_expanded: STRING_32
		do
			l_area := area; new_characters_area := new_characters.area; l_count := count
			l_new_unencoded := empty_once_unencoded; l_unencoded := unencoded_interval_index
			old_expanded := old_characters.as_expanded (1); new_expanded := new_characters.as_expanded (2)
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
						l_new_unencoded.extend_z_code (new_z_code, j + 1)
						l_area.put (Unencoded_character, j)
					else
						l_area.put (new_z_code.to_character_8, j)
					end
					j := j + 1
				end
				i := i + 1
			end
			set_count (j)
			l_area [j] := '%U'
			set_from_extendible_unencoded (l_new_unencoded)
			reset_hash
		ensure
			valid_unencoded: is_unencoded_valid
			unchanged_count: not delete_null implies count = old count
			changed_count: delete_null implies count = old (count - deleted_count (old_characters, new_characters))
		end

	translate_general (old_characters, new_characters: READABLE_STRING_GENERAL)
		do
			translate (adapted_argument (old_characters, 1), adapted_argument (new_characters, 2))
		end

	unescape (unescaper: EL_ZSTRING_UNESCAPER)
		do
			make_from_other (unescaped (unescaper))
		end

feature {EL_READABLE_ZSTRING} -- Replacement

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
				adapted_argument (left, 1), adapted_argument (right, 2), adapted_argument (new, 3), include_delimiter, start_index
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
			replaced: elks_checking implies
				(current_readable ~ (old (substring (1, start_index - 1) + s + substring (end_index + 1, count))))
			valid_unencoded: is_unencoded_valid
		end

	replace_substring_all (original, new: EL_READABLE_ZSTRING)
		local
			replace_not_done: BOOLEAN; positions: ARRAYED_LIST [INTEGER]
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
						internal_replace_substring_all (original, new)
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
			replace_substring (adapted_argument (s, 1), start_index, end_index)
		end

	replace_substring_general_all (original, new: READABLE_STRING_GENERAL)
		do
			replace_substring_all (adapted_argument (original, 1), adapted_argument (new, 2))
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
			if has_mixed_encoding and then unencoded_last_upper > n then
				if n = 0 then
					make_unencoded
				else
					set_from_extendible_unencoded (unencoded_substring (1, n))
				end
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
				if n = 0 then
					make_unencoded
				else
					set_from_extendible_unencoded (unencoded_substring (old_count - n + 1, old_count))
				end
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
				set_count (0)
				reset_hash
			else
				keep_tail (count - n)
			end
		ensure
			removed: elks_checking implies current_readable ~ (old substring (n.min (count) + 1, count))
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
				set_count (0)
				reset_hash
			else
				keep_head (l_count - n)
			end
		ensure
			removed: elks_checking implies current_readable ~ (old substring (1, count - n.min (count)))
		end

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

feature -- Contract Support

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

feature {NONE} -- Implementation

	internal_substring_index_list (str: EL_READABLE_ZSTRING): ARRAYED_LIST [INTEGER]
		deferred
		end

	substring_index (other: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		deferred
		end

end