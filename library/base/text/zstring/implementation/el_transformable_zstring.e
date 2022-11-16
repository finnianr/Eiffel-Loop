note
	description: "Implementation routines to transform instance of [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "28"

deferred class
	EL_TRANSFORMABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_APPENDABLE_ZSTRING

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
			internal_fill_character (c)
			if c = Substitute then
				make_unencoded_filled (uc, count)
			end
		end

	mirror
			-- Reverse the order of characters.
			-- "Hello" -> "olleH".
		local
			c_i: CHARACTER; i, l_count: INTEGER; l_area: like area
			buffer: like empty_unencoded_buffer; unencoded: like unencoded_indexable
		do
			l_count := count
			if l_count > 1 then
				if has_mixed_encoding then
					buffer := empty_unencoded_buffer
					l_area := area; unencoded := unencoded_indexable
					from i := l_count - 1 until i < 0 loop
						c_i := l_area.item (i)
						if c_i = Substitute then
							buffer.extend (unencoded.item (i + 1), l_count - i)
						end
						i := i - 1
					end
					internal_mirror
					set_unencoded_from_buffer (buffer)
				else
					internal_mirror
				end
			end
		ensure
			same_count: count = old count
			valid_string: is_valid
			reversed: across 1 |..| count as n all item (n.item) = (old twin) [count - n.item + 1] end
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
			is_space, is_space_state: BOOLEAN; z_code_array: ARRAYED_LIST [NATURAL]; l_z_code: NATURAL
			c: EL_CHARACTER_32_ROUTINES; unencoded: like unencoded_indexable
		do
			if not is_canonically_spaced then
				l_area := area; l_count := count; unencoded := unencoded_indexable
				create z_code_array.make (l_count)
				from i := 0 until i = l_count loop
					c_i := l_area [i]
					if c_i = Substitute then
						is_space := c.is_space (unencoded_item (i + 1)) -- Work around for finalization bug
						l_z_code := unencoded.z_code (i + 1)
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
			l_new_unencoded: like empty_unencoded_buffer; unencoded: like unencoded_indexable
			l_area, new_characters_area: like area; old_expanded, new_expanded: STRING_32
		do
			old_expanded := old_characters.as_expanded (1); new_expanded := new_characters.as_expanded (2)

			l_area := area; new_characters_area := new_characters.area; l_count := count
			l_new_unencoded := empty_unencoded_buffer
			unencoded := unencoded_indexable -- must be assigned only after calls to `as_expanded'
			from until i = l_count loop
				old_z_code := area_z_code (l_area, unencoded, i)
				index := old_expanded.index_of (old_z_code.to_character_32, 1)
				if index > 0 then
					new_z_code := new_expanded.code (index)
				else
					new_z_code := old_z_code
				end
				if delete_null implies new_z_code > 0 then
					if new_z_code > 0xFF then
						l_new_unencoded.extend_z_code (new_z_code, j + 1)
						l_area.put (Substitute, j)
					else
						l_area.put (new_z_code.to_character_8, j)
					end
					j := j + 1
				end
				i := i + 1
			end
			set_count (j)
			l_area [j] := '%U'
			set_unencoded_from_buffer (l_new_unencoded)
		ensure
			valid_unencoded: is_valid
			unchanged_count: not delete_null implies count = old count
			changed_count: delete_null implies count = old (count - deleted_count (old_characters, new_characters))
		end

	translate_general (old_characters, new_characters: READABLE_STRING_GENERAL)
		do
			translate (adapted_argument (old_characters, 1), adapted_argument (new_characters, 2))
		end

	unescape (unescaper: EL_ZSTRING_UNESCAPER)
		do
			make_from_zcode_area (unescaper.unescaped_array (current_readable))
		end

feature {EL_READABLE_ZSTRING} -- Replacement

	replace_character (uc_old, uc_new: CHARACTER_32)
		local
			c_old, c_new: CHARACTER; i, l_count: INTEGER; l_area: like area
			unencoded: like unencoded_indexable; new_unencoded: CHARACTER_32
		do
			c_old := encoded_character (uc_old)
			c_new := encoded_character (uc_new)
			if c_new = Substitute then
				new_unencoded := uc_new
			end
			l_area := area; l_count := count
			if c_old = Substitute then
				if has_mixed_encoding then
					unencoded := unencoded_indexable
					from i := 0 until i = l_count loop
						if l_area [i] = Substitute and then uc_old = unencoded.item (i + 1) then
							l_area [i] := c_new
						end
						i := i + 1
					end
					replace_unencoded_character (uc_old, new_unencoded, False)
				end
			else
				from i := 0 until i = l_count loop
					if l_area [i] = c_old then
						l_area [i] := c_new
						if c_new = Substitute then
							put_unencoded (new_unencoded, i + 1)
						end
					end
					i := i + 1
				end
			end
			reset_hash
		ensure
			valid_unencoded: is_valid
			replaced: uc_old /= uc_new implies occurrences (uc_new) = old (occurrences (uc_old) + occurrences (uc_new))
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
		local
			buffer: like empty_unencoded_buffer; l_count, old_count: INTEGER
		do
			old_count := count
			internal_replace_substring (s, start_index, end_index)
			inspect respective_encoding (s)
				when Both_have_mixed_encoding then
					l_count := start_index - 1
					buffer := empty_unencoded_buffer
					if has_unencoded_between (start_index, end_index) then
						if l_count.to_boolean then
							buffer.append_substring (Current, 1, start_index - 1, 0)
						end
						if s.count.to_boolean then
							buffer.append (s, l_count)
						end
						if end_index < old_count then
							buffer.append_substring (Current, end_index + 1, old_count, l_count + s.count)
						end
						set_unencoded_from_buffer (buffer)
					else
						shift_unencoded_from (start_index, s.count - (end_index - start_index + 1))
						buffer.append (s, l_count)
						insert_unencoded (buffer)
--						buffer.set_in_use (False)
					end

				when Only_current then
					remove_unencoded_substring (start_index, end_index)
					shift_unencoded_from (start_index, s.count)

				when Only_other then
					unencoded_area := s.unencoded_area.twin
					shift_unencoded (start_index - 1)
			else
			end
		ensure
			new_count: count = old count - (end_index - start_index + 1) + old s.count
			replaced: elks_checking implies
				(current_readable ~ (old (substring (1, start_index - 1) + s + substring (end_index + 1, count))))
			valid_unencoded: is_valid
		end

	replace_substring_all (old_substring, new_substring: EL_READABLE_ZSTRING)
		local
			old_count, l_count, new_substring_count, old_substring_count, previous_index, end_index, size_difference: INTEGER
			buffer: like empty_unencoded_buffer; substring_index_list: detachable LIST [INTEGER]
			replaced_8, current_8, new_substring_8: EL_STRING_8; internal_replace_done: BOOLEAN
		do
			if not old_substring.is_equal (new_substring) then
				old_count := count; new_substring_count := new_substring.count; old_substring_count := old_substring.count
				size_difference := new_substring_count - old_substring_count
				previous_index := 1

				inspect respective_encoding (old_substring)
					when Both_have_mixed_encoding then
						substring_index_list := internal_substring_index_list (old_substring)

					when Only_current then
						if new_substring.has_mixed_encoding then
							if attached internal_substring_index_list (old_substring) as positions
								and then positions.count > 0
							then
								internal_replace_substring_all (old_substring, new_substring)
								internal_replace_done := True
								substring_index_list := positions
							end

						elseif attached internal_substring_index_list (old_substring) as positions
							and then positions.count > 0
						then
							internal_replace_substring_all (old_substring, new_substring)
							buffer := empty_unencoded_buffer
							from positions.start until positions.after loop
								end_index := positions.item - 1
								if end_index >= previous_index then
									buffer.append_substring (Current, previous_index, end_index, l_count)
									l_count := l_count + end_index - previous_index + 1
								end
								l_count := l_count + new_substring_count
								previous_index := positions.item + old_substring_count
								positions.forth
							end
							end_index := old_count
							if previous_index <= end_index then
								buffer.append_substring (Current, previous_index, end_index, l_count)
							end
							set_unencoded_from_buffer (buffer)
						end

					when Only_other then
						-- since old_substring cannot match anything
						do_nothing

					when Neither then
						if new_substring.has_mixed_encoding then
							if attached internal_substring_index_list (old_substring) as positions
								and then positions.count > 0
							then
								internal_replace_substring_all (old_substring, new_substring)
								buffer := empty_unencoded_buffer
								from positions.start until positions.after loop
									end_index := positions.item - 1
									if end_index >= previous_index then
										l_count := l_count + end_index - previous_index + 1
									end
									buffer.append (new_substring, l_count)
									l_count := l_count + new_substring_count
									previous_index := positions.item + old_substring_count
									positions.forth
								end
								set_unencoded_from_buffer (buffer)
							end
						else
							-- Can use STRING_8 implemenation
							internal_replace_substring_all (old_substring, new_substring)
						end
				else
					substring_index_list := internal_substring_index_list (old_substring)
				end
				if attached substring_index_list as positions and then positions.count > 0 then
					buffer := empty_unencoded_buffer

					if not internal_replace_done then
						current_8 := string_8_argument (Current, 1)
						new_substring_8 := string_8_argument (new_substring, 2)
						create area.make_filled ('%U', old_count + size_difference * positions.count + 1)
						set_count (0); replaced_8 := current_string_8
					end
					from positions.start until positions.after loop
						end_index := positions.item - 1
						if end_index >= previous_index then
							if has_mixed_encoding then
								buffer.append_substring (Current, previous_index, end_index, l_count)
							end
							if not internal_replace_done then
								replaced_8.append_substring (current_8, previous_index, end_index)
							end
							l_count := l_count + end_index - previous_index + 1
						end
						if new_substring.has_mixed_encoding then
							buffer.append (new_substring, l_count)
						end
						if not internal_replace_done then
							replaced_8.append (new_substring_8)
						end
						l_count := l_count + new_substring_count
						previous_index := positions.item + old_substring_count
						positions.forth
					end
					end_index := old_count
					if previous_index <= end_index then
						if has_mixed_encoding then
							buffer.append_substring (Current, previous_index, end_index, l_count)
						end
						if not internal_replace_done then
							replaced_8.append_substring (current_8, previous_index, end_index)
						end
					end
					if not internal_replace_done then
						set_from_string_8 (replaced_8)
					end
					set_unencoded_from_buffer (buffer)
				end
			end
		end

	replace_substring_general (s: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
		do
			replace_substring (adapted_argument (s, 1), start_index, end_index)
		end

	replace_substring_general_all (old_substring, new_substring: READABLE_STRING_GENERAL)
		do
			replace_substring_all (adapted_argument (old_substring, 1), adapted_argument (new_substring, 2))
		end

feature {EL_READABLE_ZSTRING} -- Removal

	keep_head (n: INTEGER)
			-- Remove all characters except for the first `n';
			-- do nothing if `n' >= `count'.
		local
			old_count: INTEGER; buffer: like empty_unencoded_buffer
		do
			old_count := count
			internal_keep_head (n)
			if has_mixed_encoding and then unencoded_last_upper > n then
				if n = 0 then
					make_unencoded
				else
					buffer := empty_unencoded_buffer
					buffer.append_substring (Current, 1, n, 0)
					set_unencoded_from_buffer (buffer)
				end
			end
		ensure then
			valid_unencoded: is_valid
		end

	keep_tail (n: INTEGER)
			-- Remove all characters except for the last `n';
			-- do nothing if `n' >= `count'.
		local
			old_count: INTEGER; buffer: like empty_unencoded_buffer
		do
			old_count := count
			internal_keep_tail (n)
			if n < old_count and then has_mixed_encoding then
				if n = 0 then
					make_unencoded
				else
					buffer := empty_unencoded_buffer
					buffer.append_substring (Current, old_count - n + 1, old_count, 0)
					set_unencoded_from_buffer (buffer)
				end
			end
		ensure then
			valid_unencoded: is_valid
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
		local
			leading_count: INTEGER
		do
			leading_count := leading_white_space
			if leading_count.to_boolean then
				remove_head (leading_white_space)
			end
		end

	right_adjust
		-- Remove trailing whitespace.
		local
			trailing_count: INTEGER
		do
			trailing_count := trailing_white_space
			if trailing_count.to_boolean then
				remove_tail (trailing_count)
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

	occurrences (uc: CHARACTER_32): INTEGER
		deferred
		end

	substring_index (other: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		deferred
		end

end