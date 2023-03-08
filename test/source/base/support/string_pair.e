note
	description: "[
		Object for testing [$source ZSTRING] against [$source STRING_32] in [$source ZSTRING_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-08 14:23:05 GMT (Wednesday 8th March 2023)"
	revision: "22"

class
	STRING_PAIR

inherit
	ANY
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

feature -- STRING_32

	s_32: STRING_32

	s_32_new: STRING_32

	s_32_old: STRING_32

	s_32_substring: READABLE_STRING_32

	s_8: detachable STRING_8

feature -- STRING_8

	s_8_new: detachable STRING_8

	s_8_old: detachable STRING_8

	s_8_substring: detachable READABLE_STRING_8

feature -- ZSTRING

	zs: ZSTRING

	zs_new: ZSTRING

	zs_old: ZSTRING

	zs_substring: ZSTRING

feature -- Access

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
			b2 := zs.ends_with (s_32_substring)
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
				create {EL_SPLIT_ZSTRING_LIST}.make_by_string (zs, zs_substring),
				create {EL_SPLIT_INTERVALS}.make_by_string (s_32, s_32_substring),
				create {EL_SPLIT_STRING_32_LIST}.make_by_string (s_32, s_32_substring),
				create {EL_SPLIT_STRING_32_LIST}.make_by_string (s_32, zs_substring)
			>>)
			if attached s_8_substring as str_8 then
				intervals_list.extend (create {EL_SPLIT_INTERVALS}.make_by_string (zs, str_8))
				intervals_list.extend (create {EL_SPLIT_ZSTRING_LIST}.make_by_string (zs, str_8))

				if attached s_8 as target_8 then
					intervals_list.extend (create {EL_SPLIT_STRING_8_LIST}.make_by_string (target_8, str_8))
					intervals_list.extend (create {EL_SPLIT_STRING_8_LIST}.make_by_string (target_8, zs_substring))
				end
			end
			Result := across intervals_list as list all list.item.same_as (intervals_s_32) end
		end

	starts_with: BOOLEAN
		local
			b1, b2, b3: BOOLEAN
		do
			b1 := s_32.starts_with (s_32_substring)
			b2 := zs.starts_with (s_32_substring)
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

	double_substring (input, output: ZSTRING; start_index, end_index: INTEGER)
		do
			output.append_substring (input, start_index, end_index)
			output.append_substring (input, start_index, end_index)
		end

	double_substring_8 (input, output: STRING_8; start_index, end_index: INTEGER)
		do
			output.append_substring (input, start_index, end_index)
			output.append_substring (input, start_index, end_index)
		end

	double_substring_32 (input, output: STRING_32; start_index, end_index: INTEGER)
		do
			output.append_substring (input, start_index, end_index)
			output.append_substring (input, start_index, end_index)
		end

end