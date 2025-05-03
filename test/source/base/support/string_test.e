note
	description: "[
		Compare result of ${ZSTRING} routines with ${STRING_32} and ${STRING_8}.
		See test set ${ZSTRING_TEST_SET}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-03 12:56:41 GMT (Saturday 3rd May 2025)"
	revision: "46"

class
	STRING_TEST

inherit
	STRING_TEST_BASE

create
	make, make_empty

feature -- Access

	append_type_name (type: INTEGER): STRING
		do
			Result := Extension_routines [type]
		end

	hash_code: INTEGER
		do
			across << s_32, s_32_substring, s_32_old, s_32_new >> as list loop
				if attached list.item as str_32 then
					Result := Result + str_32.hash_code
				end
			end
			Result := Result.abs
		end

	latin_1: detachable STRING_8
		do
			if s_32.is_valid_as_string_8 then
				Result := s_32.to_string_8
			end
		end

	prune_type_name (type: INTEGER): STRING
		do
			Result := Pruning_routines [type]
		end

feature -- s_32 intervals

	all_word_interval_permutations: ARRAY [EL_SPLIT_INTERVALS]
		do
			Result := << word_intervals, double_word_intervals, split_word_intervals, sandwiched_word_intervals >>
		end

	double_word_intervals: EL_SPLIT_INTERVALS
		-- pairs of words on boundary
		do
			if attached word_intervals as list then
				create Result.make_sized (list.count)
				from list.start until list.after loop
					if not list.islast then
						Result.extend (list.item_lower, list.i_th_upper (list.index + 1))
					end
					list.forth
				end
			end
		end

	new_intervals (separator: CHARACTER_32): EL_SPLIT_INTERVALS
		do
			create Result.make (s_32, separator)
		end

	sandwiched_word_intervals: EL_SPLIT_INTERVALS
		-- words sandwiched by one space each end
		do
			if attached word_intervals as list then
				create Result.make_sized (list.count)
				from list.start until list.after loop
					if not (list.isfirst or list.islast) then
						Result.extend (list.item_lower - 1, list.item_upper + 1)
					end
					list.forth
				end
			end
		end

	split_word_intervals: EL_SPLIT_INTERVALS
		-- intervals that go from mid-word to next mid-word for adjacent words greater than 3 in length
		local
			lower, next_lower, upper, l_count, next_count: INTEGER
		do
			if attached word_intervals as list then
				create Result.make_sized (list.count)
				from list.start until list.after loop
					if not list.islast then
						l_count := list.item_count; next_count := list.i_th_count (list.index + 1)
						if l_count >= 3 and then next_count >= 3 then
							lower := list.item_lower
							next_lower := list.i_th_lower (list.index + 1)
							Result.extend (lower + l_count // 2, next_lower + next_count // 2)
						end
					end
					list.forth
				end
			end
		end

	word_intervals: EL_SPLIT_INTERVALS
		do
			Result := new_intervals (' ')
		end

feature -- Test concatenation

	append_string_general: BOOLEAN
		do
			if attached s_8_substring as str_8 then
				zs.append_string_general (str_8)
			else
				zs.append_string_general (s_32_substring)
			end
			if zs.count = s_32.count then
				Result := zs.to_string_32 ~ s_32
			else
				Result := s_32.starts_with (zs.to_string_32)
			end
		end

	append_substring_general (start_index, end_index: INTEGER): BOOLEAN
		do
			if attached s_8 as s then
				zs.append_substring_general (s, start_index, end_index)
			else
				zs.append_substring_general (s_32, start_index, end_index)
			end
			if zs.count = s_32.count then
				Result := zs.to_string_32 ~ s_32
			else
				Result := s_32.starts_with (zs.to_string_32)
			end
		end

	prepend_string_general: BOOLEAN
		do
			if attached s_8_substring as str_8 then
				zs.prepend_string_general (str_8)
			else
				zs.prepend_string_general (s_32_substring)
			end
			if zs.count = s_32.count then
				Result := zs.to_string_32 ~ s_32
			else
				Result := s_32.ends_with (zs.to_string_32)
			end
		end

feature -- Test editing

	occurrence_edit: BOOLEAN
		local
			double_spaced_32: STRING_32; editor_32: EL_STRING_32_OCCURRENCE_EDITOR
			double_spaced_8: STRING_8; editor_8: EL_STRING_8_OCCURRENCE_EDITOR
			double_spaced: ZSTRING; editor: EL_ZSTRING_OCCURRENCE_EDITOR
		do
			double_spaced_32 := s_32.twin
			double_spaced_32.replace_substring_all (" ", "  ")
			create editor_32.make (s_32, ' ')
			editor_32.apply (agent double_substring_32)
			Result := double_spaced_32 ~ s_32
			if Result then
				double_spaced := double_spaced_32
				create editor.make (zs, ' ')
				editor.apply (agent double_substring)
				Result := double_spaced ~ zs
			end
			if Result and then attached s_8 as str_8 then
				double_spaced_8 := double_spaced_32.as_string_8
				create editor_8.make (str_8, ' ')
				editor_8.apply (agent double_substring_8)
				Result := double_spaced_8 ~ str_8
			end
		end

	insert_remove (insert: ZSTRING; index: INTEGER): BOOLEAN
		local
			end_index, old_count: INTEGER
		do
			old_count := zs.count
			zs.insert_string (insert, index)
			s_32.insert_string (insert.to_string_32, index)
			if zs.same_string (s_32) then
				end_index := index + insert.count - 1
				zs.remove_substring (index, end_index)
				s_32.remove_substring (index, end_index)
				Result := old_count = zs.count and then zs.same_string (s_32)
			end
		end

	prune_all (uc: CHARACTER_32)
		do
			zs.prune_all (uc); s_32.prune_all (uc)
			test.assert_same_string (Void, zs, s_32)
		end

	prune_set_members (a_set: EL_HASH_SET [CHARACTER_32]; set_8: EL_HASH_SET [CHARACTER_8])
		do
			zs.prune_set_members (a_set)
			across a_set as c loop
				if s_32.has (c.item) then
					s_32.prune_all (c.item)
				end
			end
			test.assert_same_string (Void, zs, s_32)
			if attached s_8 as str_8 then
				super_8 (str_8).prune_set_members (set_8)
				test.assert_same_string (Void, str_8, s_32)
			end
		end

	replace_set_members (a_set: EL_HASH_SET [CHARACTER_32]; set_8: EL_HASH_SET [CHARACTER_8])
		local
			bar_count: INTEGER
		do
			zs.replace_set_members (a_set, '|')
			across a_set as c loop
				if s_32.has (c.item) then
					super_32 (s_32).replace_character (c.item, '|')
				end
			end
			bar_count := s_32.occurrences ('|')
			test.assert ("same count of '|'", zs.occurrences ('|') = bar_count)
			if attached s_8 as str_8 then
				super_8 (str_8).replace_set_members (set_8, '|')
				test.assert ("same count of '|'", str_8.occurrences ('|') = bar_count)
			end
		end

	replace_substring_all: BOOLEAN
		do
			s_32.replace_substring_all (s_32_old, s_32_new)
			if attached s_8_old as l_old and attached s_8_new as l_new then
				zs.replace_substring_all (l_old, l_new)

			elseif attached s_8_new as l_new then
				zs.replace_substring_all (zs_old, l_new)

			elseif attached s_8_old as l_old then
				zs.replace_substring_all (l_old, zs_new)
			else
				zs.replace_substring_all (zs_old, zs_new)
			end
			Result := zs.same_string (s_32)
		end

	translate (and_delete: BOOLEAN): BOOLEAN
		local
			old_set, new_set: READABLE_STRING_GENERAL
		do
			if attached s_8_old as str_8 then
				old_set := str_8
			else
				old_set := s_32_old
			end
			if attached s_8_new as str_32 then
				new_set := str_32
			else
				new_set := s_32_new
			end
			if and_delete then
				super_32 (s_32).translate_or_delete (old_set, new_set)
				zs.translate_or_delete (old_set, new_set)
			else
				super_32 (s_32).translate (old_set, new_set)
				zs.translate (old_set, new_set)
			end
			Result := zs.same_string (s_32)
		end

feature -- Test comparisons

	same_characters (index: INTEGER): BOOLEAN
		local
			b1, b2, b3: BOOLEAN
		do
			b1 := s_32.same_characters (s_32_substring, 1, s_32_substring.count, index)
			b2 := zs.same_characters (s_32_substring, 1, s_32_substring.count, index)
			b3 := zs.same_characters (zs_substring, 1, zs_substring.count, index)
			Result := b1 = b2
			Result := Result and b1 = b3
			if Result and then attached s_8_substring as s then
				b3 := zs.same_characters_general (s, 1, s.count, index)
				Result := b1 = b3
			end
		end

	same_substring (start_index, end_index: INTEGER): BOOLEAN
		local
			substring: ZSTRING
		do
			substring := zs.substring (start_index, end_index)
			Result := substring.to_string_32 ~ s_32.substring (start_index, end_index)
		end

	same_string
		-- EL_EXTENDED_READABLE_ZSTRING.same_string
		local
			found: BOOLEAN; count, index_space: INTEGER
			last_word: READABLE_STRING_GENERAL
		do
			if attached new_general_substring_list as substring_list then
				across new_general_list as list loop
					if attached list.item as general then
						index_space := general.last_index_of (' ', general.count)
						last_word := general.substring (index_space + 1, general.count)
						found := False
						across substring_list as list_2 until found loop
							if attached list_2.item as substring
								and then last_word.same_type (substring)
							then
								test.assert ("same string", super_readable_general (last_word).same_string (substring))
								found := True; count := count + 1
							end
						end
					end
				end
				test.assert (" tests", count = substring_list.count)
			end
		end

feature -- Test splitting

	occurrence_intervals
		local
			zstring_intervals, string_32_intervals, string_8_intervals: EL_OCCURRENCE_INTERVALS
			intervals_s_32: EL_SEQUENTIAL_INTERVALS
		do
			intervals_s_32 := new_occurrence_intervals (s_32, s_32_substring)

			create zstring_intervals.make_by_string (zs, zs_substring)
			test.assert ("same as zstring", zstring_intervals.same_as (intervals_s_32))

			create string_32_intervals.make_by_string (s_32, s_32_substring)
			test.assert ("same as string_32", string_32_intervals.same_as (intervals_s_32))

			if attached s_8_substring as str_8 then
				create string_8_intervals.make_by_string (zs, str_8)
				test.assert ("same as string_8", string_8_intervals.same_as (intervals_s_32))
			end
		end

	split_intervals
		local
			intervals_list: ARRAYED_LIST [EL_OCCURRENCE_INTERVALS]
			intervals_s_32: EL_SEQUENTIAL_INTERVALS
		do
			intervals_s_32 := new_split_intervals (s_32, s_32_substring)

			create intervals_list.make_from_array (<<
				create {EL_SPLIT_INTERVALS}.make_by_string (zs, zs_substring),
				create {EL_SPLIT_INTERVALS}.make_by_string (s_32, s_32_substring) --,
			>>)
			if attached s_8_substring as str_8 then
				intervals_list.extend (create {EL_SPLIT_INTERVALS}.make_by_string (zs, str_8))
			end
			across intervals_list as list loop
				test.assert ("same item", list.item.same_as (intervals_s_32))
			end
		end

	split_lists
		local
			s: EL_STRING_32_ROUTINES; item_32: STRING_32
		do
			if attached new_split_list_array as split_list_array
				and then attached s.split_intervals (s_32, s_32_substring, True) as interval
			then
				from interval.start until interval.after loop
					item_32 := s_32.substring (interval.item_lower, interval.item_upper)
					across split_list_array as array loop
						if attached array.item as split_list then
							split_list.go_i_th (interval.index)
							test.assert ("same item", split_list.item_same_as (item_32))
						end
					end
					interval.forth
				end
			end
		end

	word_split_intervals (word_list: EL_STRING_32_LIST)
		local
			interval_item: STRING_32; bounds_list: EL_SPLIT_WORD_INTERVALS; string_types: ARRAY [STRING_GENERAL]
			start_index, end_index, first_index, last_index, delta: INTEGER; c32: EL_CHARACTER_32_ROUTINES
		do
			string_types := << s_32, zs >>
			across string_types as type loop
				if attached type.item as str then
					create bounds_list.make (str)
					if c32.is_space (s_32 [1]) then
						test.assert ("first is empty", bounds_list.first_count = 0)
						first_index := 2
					else
						first_index := 1
					end
					if c32.is_space (s_32 [s_32.count]) then
						test.assert ("last is empty", bounds_list.last_count = 0)
						last_index := bounds_list.count - 1
					else
						last_index := bounds_list.count
					end
					test.assert ("same word count", last_index - first_index + 1 = word_list.count)

					if attached bounds_list as list then
						from list.go_i_th (first_index) until list.index > last_index loop
							interval_item := str.substring (list.item_lower, list.item_upper)
							test.assert_same_string (Void, word_list [list.index - first_index + 1], interval_item)
							list.forth
						end
					end
				end
			end
		end

feature -- Test search

	substring_index (from_index: INTEGER): BOOLEAN
		local
			index_1, index_2: INTEGER
		do
			index_1 := s_32.substring_index (s_32_substring, from_index)
			index_2 := zs.substring_index (zs_substring, from_index)
			Result := index_1 = index_2
			if Result then
				index_2 := zs.substring_index (s_32_substring, from_index)
				Result := index_1 = index_2
			end
			if Result and then attached s_8_substring as str_8 then
				index_2 := zs.substring_index (s_8_substring, from_index)
				Result := index_1 = index_2
			end
		end

	substring_index_in_bounds (target_32: STRING_32; target: ZSTRING; start_pos, end_pos: INTEGER): BOOLEAN
		local
			index: INTEGER
		do
			index := target_32.substring_index_in_bounds (s_32_substring, start_pos, end_pos)
			if index > 0 then
				Result := index = target.substring_index_in_bounds (zs_substring, start_pos, end_pos)
				if Result then
					Result := index = target.substring_index_in_bounds (s_32_substring, start_pos, end_pos)
				end
				if Result and attached s_8_substring as str_8 then
					Result := index = target.substring_index_in_bounds (str_8, start_pos, end_pos)
				end
			end
		end

	substring_index_list: BOOLEAN
		local
			intervals: EL_OCCURRENCE_INTERVALS
		do
			create intervals.make_by_string (s_32, s_32_substring)
			Result := same_indices (zs.substring_index_list (zs_substring, False), intervals)
			if Result then
				Result := same_indices (zs.substring_index_list_general (s_32_substring, False), intervals)
			end
			if Result and then attached s_8_substring as str_8 then
				Result := same_indices (zs.substring_index_list_general (s_8_substring, False), intervals)
			end
		end

feature -- Conversion

	to_general: BOOLEAN
		do
			if attached s_8 as str_8 then
				create zs.make_from_general (str_8)
				if attached {STRING_8} zs.to_general as as_str_8 then
					Result := as_str_8 ~ str_8
				end
			elseif attached {STRING_32} zs.to_general as str_32 then
				Result := str_32 ~ s_32
			end
		end

feature -- Status query

	ends_with: BOOLEAN
		local
			b1, b2, b3: BOOLEAN
		do
			b1 := s_32.ends_with (s_32_substring)
			if zs.ends_with (s_32_substring) then
				b2 := zs.ends_with_character (s_32_substring [s_32_substring.count])
			end
			b3 := zs.ends_with (zs_substring)
			Result := b1 = b2
			Result := Result and b1 = b3
			if s_32_substring.count < s_32.count and then s_32.starts_with (s_32_substring) then
			--test not short ends with long
				Result := Result and not zs_substring.ends_with_general (s_32)
				if attached s_8 as str_8 then
					Result := Result and not zs_substring.ends_with_general (str_8)
				end
			end
			if Result and then attached s_8_substring as s then
				b3 := zs.ends_with_general (s)
				Result := b1 = b3
			end
		end

	has_enclosing
		local
			first, last: CHARACTER_32; first_8, last_8: CHARACTER_8; offset: INTEGER
			is_zs_enclosed: BOOLEAN
		do
			from offset := 1 until offset < 0 loop
				first := s_32 [1] + offset.to_natural_32; last := s_32 [s_32.count] + offset.to_natural_32
				is_zs_enclosed := zs.has_enclosing (first, last)
				test.assert ("same result", is_zs_enclosed = super_32 (s_32).has_enclosing (first, last))
				offset := offset - 1
			end
			if attached s_8_substring as str_8 then
				is_zs_enclosed := zs.has_enclosing (first, last)
				first_8 := first.to_character_8; last_8 := last.to_character_8
				test.assert ("same result", is_zs_enclosed = super_8 (str_8).has_enclosing (first_8, last_8))
			end
		end

	is_same: BOOLEAN
		do
			Result := zs.same_string (s_32)
		end

	is_same_size: BOOLEAN
		do
			Result := zs.count = s_32.count
		end

	starts_with: BOOLEAN
		local
			b1, b2, b3: BOOLEAN
		do
			b1 := s_32.starts_with (s_32_substring)
			if zs.starts_with (s_32_substring) then
				b2 := s_32_substring.count > 0 implies zs.starts_with_character (s_32_substring [1])
			end
			b3 := zs.starts_with (zs_substring)
			Result := b1 = b2
			Result := Result and b1 = b3
			if Result and zs.count > zs_substring.count then
				Result := not zs_substring.starts_with_general (s_32)
			end
			if s_32_substring.count < s_32.count and then s_32.starts_with (s_32_substring) then
			--test not short starts with long
				Result := Result and not zs_substring.starts_with_general (s_32)
				if attached s_8 as str_8 then
					Result := Result and not zs_substring.starts_with_general (str_8)
				end
			end
			if Result and then attached s_8_substring as str_8 then
				b3 := zs.starts_with_general (str_8)
				Result := b1 = b3
			end
		end

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := s_32.valid_index (i)
		end

end