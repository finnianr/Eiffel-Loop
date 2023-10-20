note
	description: "Implementation routines to transform instance of [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-31 13:08:05 GMT (Thursday 31st August 2023)"
	revision: "52"

deferred class
	EL_TRANSFORMABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_READABLE_ZSTRING_I

	EL_APPENDABLE_ZSTRING

	EL_PREPENDABLE_ZSTRING

	EL_CHARACTER_32_CONSTANTS

feature {EL_READABLE_ZSTRING} -- Basic operations

	crop (left_delimiter, right_delimiter: CHARACTER_32)
		do
			current_readable.copy (current_readable.cropped (left_delimiter, right_delimiter))
		end

	enclose (left, right: CHARACTER_32)
		do
			current_readable.copy (current_readable.enclosed (left, right))
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
			c_i: CHARACTER; i, l_count, block_index, last_upper: INTEGER
			iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			l_count := count
			if l_count > 1 then
				if attached unencoded_area as area_32 and then area_32.count > 0
					and then attached empty_unencoded_buffer as buffer
					and then attached area as l_area
				then
					last_upper := buffer.last_upper
					from i := l_count - 1 until i < 0 loop
						c_i := l_area.item (i)
						if c_i = Substitute then
							last_upper := buffer.extend (iter.item ($block_index, area_32, i + 1), last_upper, l_count - i)
						end
						i := i - 1
					end
					String_8.mirror (Current)
					buffer.set_last_upper (last_upper)
					set_unencoded_from_buffer (buffer)
				else
					String_8.mirror (Current)
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
		do
			current_readable.copy (current_readable.multiplied (n))
		end

	quote (type: INTEGER)
		require
			type_is_single_double_or_appropriate: 1 <= type and type <= 3
		do
			current_readable.copy (current_readable.quoted (type))
		end

	to_canonically_spaced
		-- adjust so that `is_canonically_spaced' becomes true
		local
			c_i: CHARACTER; uc_i: CHARACTER_32; i, j, l_count, block_index, space_count, last_upper: INTEGER
			is_space, is_space_state: BOOLEAN; c: EL_CHARACTER_32_ROUTINES
			iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			if not is_canonically_spaced
				and then attached unencoded_area as area_32 and then attached area as l_area
				and then attached empty_unencoded_buffer as buffer
			then
				last_upper := buffer.last_upper
				l_count := count
				from i := 0; j := 0 until i = l_count loop
					c_i := l_area [i]
					if c_i = Substitute then
						uc_i := iter.item ($block_index, area_32, i + 1)
						 -- `c.is_space' is workaround for finalization bug
						is_space := c.is_space (uc_i)
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
							l_area [j] := c_i
							if c_i = Substitute then
								last_upper := buffer.extend (uc_i, last_upper, j + 1)
							end
							j := j + 1

						when 1 then
							l_area [j] := ' '
							j := j + 1
					else
					end
					i := i + 1
				end
				set_count (j)
				buffer.set_last_upper (last_upper)
				set_unencoded_from_buffer (buffer)
				if (i - j) > 20 then
					trim
				end
			end
		ensure
			canonically_spaced: is_canonically_spaced
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

	translate (old_characters, new_characters: READABLE_STRING_GENERAL)
		do
			translate_deleting_null_characters (
				adapted_argument (old_characters, 1), adapted_argument (new_characters, 2), False
			)
		end

	translate_deleting_null_characters (old_characters, new_characters: EL_READABLE_ZSTRING; delete_null: BOOLEAN)
		-- substitute characters occurring in `old_characters' with character
		-- at same position in `new_characters'. If `delete_null' is true, remove any characters
		-- corresponding to null value '%U'
		require
			each_old_has_new: old_characters.count = new_characters.count
		local
			i, j, index, l_count, block_index, last_upper: INTEGER; old_z_code, new_z_code: NATURAL
			old_expanded, new_expanded: STRING_32; l_area, new_characters_area: like area
			iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			old_expanded := old_characters.shared_z_code_pattern (1); new_expanded := new_characters.shared_z_code_pattern (2)

			l_area := area; new_characters_area := new_characters.area; l_count := count

			if attached empty_unencoded_buffer as l_new_unencoded and then attached unencoded_area as area_32 then
				last_upper := l_new_unencoded.last_upper
				from until i = l_count loop
					old_z_code := iter.i_th_z_code ($block_index, l_area, area_32, i)
					index := old_expanded.index_of (old_z_code.to_character_32, 1)
					if index > 0 then
						new_z_code := new_expanded.code (index)
					else
						new_z_code := old_z_code
					end
					if delete_null implies new_z_code > 0 then
						if new_z_code > 0xFF then
							last_upper := l_new_unencoded.extend_z_code (new_z_code, last_upper, j + 1)
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
				l_new_unencoded.set_last_upper (last_upper)
				set_unencoded_from_buffer (l_new_unencoded)
			end
		ensure
			valid_unencoded: is_valid
			unchanged_count: not delete_null implies count = old count
			changed_count: delete_null implies count = old (count - deleted_count (old_characters, new_characters))
		end

	unescape (unescaper: EL_ZSTRING_UNESCAPER)
		do
			make_from_zcode_area (unescaper.unescaped_array (current_readable))
		end

feature {EL_READABLE_ZSTRING} -- Replacement

	expand_tabs (space_count: INTEGER)
		-- replace tabs with spaces
		do
			replace_substring_all (tab * 1, space * space_count)
		end

	replace_character (uc_old, uc_new: CHARACTER_32)
		local
			c_old, c_new: CHARACTER; i, l_count, block_index: INTEGER; l_area: like area
			iter: EL_UNENCODED_CHARACTER_ITERATION; new_unencoded: CHARACTER_32
		do
			c_old := encoded_character (uc_old)
			c_new := encoded_character (uc_new)
			if c_new = Substitute then
				new_unencoded := uc_new
			end
			l_area := area; l_count := count
			if c_old = Substitute then
				if attached unencoded_area as area_32 and then area_32.count > 0 then
					from i := 0 until i = l_count loop
						if l_area [i] = Substitute and then uc_old = iter.item ($block_index, area_32, i + 1) then
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
				adapted_argument (left, 1), adapted_argument (right, 2), adapted_argument (new, 3),
				include_delimiter, start_index
			)
		end

	replace_substring (s: EL_READABLE_ZSTRING; start_index, end_index: INTEGER)
		local
			buffer: like Unencoded_buffer; l_count, old_count: INTEGER
		do
			old_count := count
			String_8.replace_substring (Current, s, start_index, end_index)
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

	replace_substring_all (old_substring, new_substring: READABLE_STRING_GENERAL)
		local
			old_, new: ZSTRING
		do
			if old_substring.count > 0 then
				old_ := adapted_argument (old_substring, 1)
				new := adapted_argument (new_substring, 2)
				if old_ /~ new then
					if respective_encoding (new) = Neither then
						String_8.replace_substring_all (Current, old_, new)
					else
						replace_area_substrings (old_, new)
					end
				end
			end
		end

	replace_substring_general (s: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
		do
			replace_substring (adapted_argument (s, 1), start_index, end_index)
		end

feature {EL_READABLE_ZSTRING} -- Removal

	keep_head (n: INTEGER)
		-- Remove all characters except for the first `n';
		-- do nothing if `n' >= `count'.
		local
			l_count: INTEGER
		do
			if has_mixed_encoding then
				l_count := count
				if has_substitutes_between (area, n + 1, l_count) then
					remove_unencoded_substring (n + 1, l_count)
				end
			end
			internal_keep_head (n)
		ensure then
			valid_unencoded: is_valid
		end

	keep_tail (n: INTEGER)
			-- Remove all characters except for the last `n';
			-- do nothing if `n' >= `count'.
		local
			leading_count: INTEGER
		do
			leading_count := count - n
			internal_keep_tail (n)
			if has_mixed_encoding then
				if count = 0 then
					make_unencoded
				else
					if has_unencoded_between (1, leading_count) then
						remove_unencoded_substring (1, leading_count)

					elseif has_unencoded_between (leading_count + 1, leading_count + n) then
						shift_unencoded (leading_count.opposite)
					end
				end
			end
		ensure then
			valid_unencoded: is_valid
		end

	left_adjust
		-- Remove leading whitespace.
		local
			space_count, old_count: INTEGER; l_area: like area
		do
			l_area := area; old_count := count
			space_count := internal_leading_white_space (l_area, old_count)

			if space_count > 0 then
				if has_unencoded_between (1, space_count) then
					remove_head (space_count)
				else
					l_area.overlapping_move (space_count, 0, old_count - space_count)
					if has_mixed_encoding then
						shift_unencoded (space_count.opposite)
					end
					set_count (old_count - space_count)
				end
			end
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

	right_adjust
		-- Remove trailing whitespace.
		local
			trailing_count: INTEGER
		do
			trailing_count := trailing_white_space
			if trailing_count.to_boolean then
				keep_head (count - trailing_count)
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

	replace_substring_all_zstring (old_substring, new_substring: EL_READABLE_ZSTRING)
		local
			old_count, l_count, new_substring_count, old_substring_count: INTEGER
			previous_index, end_index, size_difference: INTEGER; internal_replace_done: BOOLEAN
			replaced_8, current_8, new_substring_8: EL_STRING_8
			substring_index_list: detachable LIST [INTEGER]
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
								String_8.replace_substring_all (Current, old_substring, new_substring)
								internal_replace_done := True
								substring_index_list := positions
							end

						elseif attached internal_substring_index_list (old_substring) as positions
							and then positions.count > 0
						then
							String_8.replace_substring_all (Current, old_substring, new_substring)
							if attached empty_unencoded_buffer as buffer then
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
						end

					when Only_other then
						-- since old_substring cannot match anything
						do_nothing

					when Neither then
						if new_substring.has_mixed_encoding then
							if attached internal_substring_index_list (old_substring) as positions
								and then positions.count > 0
							then
								String_8.replace_substring_all (Current, old_substring, new_substring)
								if attached empty_unencoded_buffer as buffer then
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
							end
						else
							-- Can use STRING_8 implemenation
							String_8.replace_substring_all (Current, old_substring, new_substring)
						end
				else
					substring_index_list := internal_substring_index_list (old_substring)
				end
				if attached substring_index_list as positions and then positions.count > 0
					and then attached empty_unencoded_buffer as buffer
				then
					if not internal_replace_done then
						current_8 := String_8.injected (Current, 1)
						new_substring_8 := String_8.injected (new_substring, 2)
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

	replace_area_substrings (a_old, new: ZSTRING)
		local
			i, l_count, count_delta, old_count, sum_count_delta, new_current_count: INTEGER
			previous_upper_plus_1, lower, upper, new_lower, new_upper: INTEGER
			l_area, replaced_area, new_area: like area; index_area: SPECIAL [INTEGER]
			old_index_list: ARRAYED_LIST [INTEGER]
		do
			old_count := a_old.count; count_delta := new.count - old_count

			old_index_list := internal_substring_index_list (a_old)
			if old_index_list.count > 0 then
				new_current_count := count + count_delta * old_index_list.count

				if has_mixed_encoding or new.has_mixed_encoding then
					set_replaced_unencoded (old_index_list, count_delta, a_old.count, new_current_count, new)
				end

				l_area := area; new_area := new.area; index_area := old_index_list.area
				create replaced_area.make_empty (new_current_count + 1)
				previous_upper_plus_1 := 1
				from until i = index_area.count loop
					lower := index_area [i]; upper := lower + old_count - 1
					new_lower := lower + sum_count_delta; new_upper := lower + old_count + count_delta - 1
					sum_count_delta := sum_count_delta + count_delta

					l_count := lower - previous_upper_plus_1
					if l_count > 0 then
						replaced_area.copy_data (l_area, previous_upper_plus_1 - 1, new_lower - l_count - 1, l_count)
					end
					replaced_area.copy_data (new_area, 0, new_lower - 1, new.count)
					previous_upper_plus_1 := upper + 1
					i := i + 1
				end
				l_count := count - previous_upper_plus_1 + 1
				if l_count > 0 then
					replaced_area.copy_data (l_area, previous_upper_plus_1 - 1, new_upper, l_count)
				end
				replaced_area.extend ('%U')
				check
					filled: replaced_area.count = new_current_count + 1
				end
				area := replaced_area
				set_count (new_current_count)
			end
		end

	set_replaced_unencoded (a_index_list: ARRAYED_LIST [INTEGER]; count_delta, old_count, new_count: INTEGER; new: ZSTRING)
		local
			i, l_count, sum_count_delta, block_index, block_index_new: INTEGER
			previous_upper_plus_1, lower, upper, new_lower, new_upper: INTEGER
			l_area: like area; index_area: SPECIAL [INTEGER]; area_32: SPECIAL [CHARACTER_32]
			buffer: like Unencoded_buffer; current_has_substitutes, new_has_substitutes: BOOLEAN
		do
			buffer := empty_unencoded_buffer; l_area := area; area_32 := unencoded_area
			index_area := a_index_list.area;
			current_has_substitutes := has_mixed_encoding
			new_has_substitutes := new.has_mixed_encoding
			previous_upper_plus_1 := 1
			from until i = index_area.count loop
				lower := index_area [i]; upper := lower + old_count - 1
				new_lower := lower + sum_count_delta; new_upper := lower + old_count + count_delta - 1
				sum_count_delta := sum_count_delta + count_delta

				l_count := lower - previous_upper_plus_1
				if current_has_substitutes and then l_count > 0 then
					buffer.append_substituted (
						l_area, area_32, $block_index, previous_upper_plus_1 - 1, new_lower - l_count - 1, l_count
					)
				end
				if new_has_substitutes then
					block_index_new := 0
					buffer.append_substituted (
						new.area, new.unencoded_area, $block_index_new, 0, new_lower - 1, new.count
					)
				end
				previous_upper_plus_1 := upper + 1
				i := i + 1
			end
			l_count := count - previous_upper_plus_1 + 1
			if current_has_substitutes and then l_count > 0 then
				buffer.append_substituted (
					l_area, area_32, $block_index, previous_upper_plus_1 - 1, new_upper, l_count
				)
			end
			set_unencoded_from_buffer (buffer)
		end

end
