note
	description: "[
		Compare result of [$source ZSTRING] routines with [$source STRING_32] and [$source STRING_8].
		See test set [$source ZSTRING_TEST_SET].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-16 10:17:10 GMT (Wednesday 16th August 2023)"
	revision: "25"

class
	STRING_TEST

inherit
	STRING_TEST_FIELDS
	 	redefine
	 		default_create
	 	end

create
	default_create, make, make_filled

convert
	make ({STRING_32})

feature {NONE} -- Initialization

	default_create
		do
			make_filled (' ', 0)
		end

	make (str: STRING_32)
		do
			set (str)
			s_32_substring := s_32; zs_substring := zs
		end

	make_filled (c: CHARACTER_32; n: INTEGER)
		do
			create s_32.make_filled (c, n)
			create zs.make_filled (c, n)
			s_32_substring := s_32; zs_substring := zs
		end

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

feature -- Test comparisons

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
			if Result and then attached s_8_substring as s then
				b3 := zs.ends_with_general (s)
				Result := b1 = b3
			end
		end

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

	occurrence_intervals: BOOLEAN
		local
			intervals_s_32: EL_SEQUENTIAL_INTERVALS; s: EL_STRING_32_ROUTINES
			intervals_list: ARRAYED_LIST [EL_OCCURRENCE_INTERVALS]
		do
			intervals_s_32 := s.occurrence_intervals (s_32, s_32_substring)

			create intervals_list.make_from_array (<<
				create {EL_OCCURRENCE_INTERVALS}.make_by_string (zs, zs_substring),
				create {EL_OCCURRENCE_INTERVALS}.make_by_string (s_32, s_32_substring)
			>>)
			if attached s_8_substring as str_8 then
				intervals_list.extend (create {EL_OCCURRENCE_INTERVALS}.make_by_string (zs, str_8))
			end
			Result := across intervals_list as list all list.item.same_as (intervals_s_32) end
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

	split_intervals: BOOLEAN
		local
			intervals_s_32: EL_SEQUENTIAL_INTERVALS; s: EL_STRING_32_ROUTINES
			intervals_list: ARRAYED_LIST [EL_OCCURRENCE_INTERVALS]
		do
			intervals_s_32 := s.split_intervals (s_32, s_32_substring)

			create intervals_list.make_from_array (<<
				create {EL_SPLIT_INTERVALS}.make_by_string (zs, zs_substring),
				create {EL_SPLIT_INTERVALS}.make_by_string (s_32, s_32_substring) --,
			>>)
			if attached s_8_substring as str_8 then
				intervals_list.extend (create {EL_SPLIT_INTERVALS}.make_by_string (zs, str_8))
			end
			Result := across intervals_list as list all list.item.same_as (intervals_s_32) end
		end

	split_lists: BOOLEAN
		local
			s: EL_STRING_32_ROUTINES; item_32: STRING_32
		do
			Result := True
			if attached new_split_list_array as split_list_array
				and then attached s.split_intervals (s_32, s_32_substring) as interval
			then
				from interval.start until not Result or interval.after loop
					item_32 := s_32.substring (interval.item_lower, interval.item_upper)
					across split_list_array as array until not Result loop
						if attached array.item as split_list then
							split_list.go_i_th (interval.index)
							Result := split_list.item_same_as (item_32)
						end
					end
					interval.forth
				end
			end
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
			if Result and then attached s_8_substring as str_8 then
				b3 := zs.starts_with_general (str_8)
				Result := b1 = b3
			end
		end

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

	is_same: BOOLEAN
		do
			Result := zs.same_string (s_32)
		end

	is_same_size: BOOLEAN
		do
			Result := zs.count = s_32.count
		end

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := s_32.valid_index (i)
		end

feature -- Element change

	extend_strings (type: INTEGER; other: STRING_TEST)
		do
			inspect type
				when Append then
					zs.append (other.zs);  s_32.append (other.s_32)
			else
				zs.prepend (other.zs);  s_32.prepend (other.s_32)
			end
		end

	prune (type: INTEGER; c: CHARACTER_32)
		do
			inspect type
				when Left_adjust then
					zs.left_adjust
				-- Workaround for failing post-conditions on euro symbol
				-- new_count: not is_empty implies not item (1).is_space
					euro_swap_32 (agent s_32.left_adjust)

				when Right_adjust then
					zs.right_adjust
				-- Workaround for failing post-conditions on euro symbol
				-- 	new_count: not is_empty implies not item (count).is_space
					euro_swap_32 (agent s_32.right_adjust)

				when Both_adjust then
				-- Workaround for failing post-conditions on euro symbol
				--		new_count_left: not is_empty implies not item (1).is_space
				--		new_count_right: not is_empty implies not item (count).is_space
					euro_swap (agent zs.adjust)
					euro_swap_32 (agent s_32.adjust)

				when Prune_leading then
					zs.prune_all_leading (c); s_32.prune_all_leading (c)

				when Prune_trailing then
					zs.prune_all_trailing (c); s_32.prune_all_trailing (c)
			end
		end

	set (str_32: STRING_32)
		do
			s_32 := str_32; zs := str_32
			if s_32.is_valid_as_string_8 then
				s_8 := s_32.to_string_8
			else
				s_8 := Void
			end
		end

	set_old_new (a_old, a_new: STRING_32)
		do
			s_32_old := a_old; s_32_new := a_new
			zs_old := a_old; zs_new := a_new

			if a_old.is_valid_as_string_8 then
				s_8_old := a_old
			else
				s_8_old := Void
			end
			if a_new.is_valid_as_string_8 then
				s_8_new := a_new
			else
				s_8_new := Void
			end
		end

	set_substrings (start_index, end_index: INTEGER)
		do
			s_32_substring := s_32.substring (start_index, end_index)
			create zs_substring.make_from_string (s_32_substring)

			if s_32_substring.is_valid_as_string_8 then
				s_8_substring := s_32_substring.to_string_8
			else
				s_8_substring := Void
			end
		end

feature -- Basic operations

	append_character (c: CHARACTER_32)
		do
			s_32.append_character (c)
			zs.append_character (c)
		end

	set_z_from_uc
		do
			zs := s_32
		end

	wipe_out
		do
			s_32.wipe_out; zs.wipe_out
		end

feature {NONE} -- Implementation

	new_split_list_array: ARRAYED_LIST [EL_SPLIT_READABLE_STRING_LIST [READABLE_STRING_GENERAL]]
		do
			create Result.make_from_array (<<
				create {EL_SPLIT_ZSTRING_LIST}.make_by_string (zs, zs_substring),
				create {EL_SPLIT_STRING_32_LIST}.make_by_string (s_32, s_32_substring),
				create {EL_SPLIT_STRING_32_LIST}.make_by_string (s_32, zs_substring)
			>>)
			if attached s_8_substring as str_8 then
				Result.extend (create {EL_SPLIT_ZSTRING_LIST}.make_by_string (zs, str_8))

				if attached s_8 as target_8 then
					Result.extend (create {EL_SPLIT_STRING_8_LIST}.make_by_string (target_8, str_8))
					Result.extend (create {EL_SPLIT_STRING_8_LIST}.make_by_string (target_8, zs_substring))
				end
			end
		end


end