note
	description: "Fields and implementation for class ${STRING_TEST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-04 16:32:27 GMT (Friday 4th April 2025)"
	revision: "30"

class
	STRING_TEST_BASE

inherit
	ANY

	EL_SHARED_TEST_TEXT

	EL_STRING_32_CONSTANTS

	EL_STRING_GENERAL_ROUTINES_I

feature {NONE} -- Initialization

	make_empty (a_test: like test)
		do
			make (a_test, Empty_string_32.twin)
		end

	make (a_test: like test; str_32: STRING_32)
		do
			test := a_test
			set (str_32)
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

feature -- Element change

	extend_strings (type: INTEGER; other: STRING_TEST)
		do
			inspect type
				when Append then
					zs.append (other.zs); s_32.append (other.s_32)
			else
				zs.prepend (other.zs); s_32.prepend (other.s_32)
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

	set_filled (c: CHARACTER_32; n: INTEGER)
		do
			create s_32.make_filled (c, n)
			if c.is_character_8 then
				create s_8.make_filled (c.to_character_8, n)
			end
			create zs.make_filled (c, n)
			s_32_substring := s_32; zs_substring := zs
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

			if attached s_8 as str_8 then
				s_8_substring := str_8.substring (start_index, end_index)
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

	set_zs_from_s_32
		do
			zs := s_32
		end

	wipe_out
		do
			s_32.wipe_out; zs.wipe_out
			if attached s_8 as str_8 then
				str_8.wipe_out
			end
		end

feature -- Pruning types

	Both_adjust: INTEGER = 1

	Left_adjust: INTEGER = 2

	Prune_leading: INTEGER = 3

	Prune_trailing: INTEGER = 4

	Right_adjust: INTEGER = 5

feature -- Append types

	Append: INTEGER = 1

	Prepend: INTEGER = 2

feature {NONE} -- Implementation

	double_substring (input, output: ZSTRING; start_index, end_index: INTEGER)
		do
			output.append_substring (input, start_index, end_index)
			output.append_substring (input, start_index, end_index)
		end

	double_substring_32 (input, output: STRING_32; start_index, end_index: INTEGER)
		do
			output.append_substring (input, start_index, end_index)
			output.append_substring (input, start_index, end_index)
		end

	double_substring_8 (input, output: STRING_8; start_index, end_index: INTEGER)
		do
			output.append_substring (input, start_index, end_index)
			output.append_substring (input, start_index, end_index)
		end

	euro_swap (zs_action: PROCEDURE)
		-- Workaround for failing post-conditions on euro symbol
		require
			sz_target: zs_action.target = zs
		do
			zs.replace_character (Text.Euro_symbol, '¤')
			zs_action.apply
			zs.replace_character ('¤', Text.Euro_symbol)
		end

	euro_swap_32 (s_32_action: PROCEDURE)
		-- Workaround for failing post-conditions on euro symbol
		require
			s_32_target: s_32_action.target = s_32
		do
			super_32 (s_32).replace_character (Text.Euro_symbol, '¤')
			s_32_action.apply
			super_32 (s_32).replace_character ('¤', Text.Euro_symbol)
		end

	same_indices (index_list: ARRAYED_LIST [INTEGER]; intervals: EL_OCCURRENCE_INTERVALS): BOOLEAN
		do
			if index_list.count = intervals.count and then attached intervals as list then
				Result := True
				from list.start until not Result or list.after loop
					Result := list.item_lower = index_list [list.index]
					list.forth
				end
			end
		end

feature {NONE} -- Factory

	new_general_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
		do
			create Result.make_from_array (<< s_32, zs >>)
			if attached s_8 as str_8 then
				Result.extend (str_8)
			end
		end

	new_general_substring_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
		do
			create Result.make_from_array (<< s_32_substring, zs_substring >>)
			if attached s_8_substring as str_8 then
				Result.extend (str_8)
			end
		end

	new_occurrence_intervals (a_text, pattern: STRING_32): EL_SEQUENTIAL_INTERVALS
		-- reference function to make occurence interval list of `pattern' in `a_text'
		local
			index_list: LIST [INTEGER]
		do
			String_32_searcher.initialize_deltas (pattern)
			index_list := String_32_searcher.substring_index_list_with_deltas (a_text, pattern, 1, a_text.count)
			create Result.make (index_list.count)
			across index_list as list loop
				Result.extend (list.item, list.item + pattern.count - 1)
			end
		end

	new_split_intervals (a_text, separator: STRING_32): EL_SEQUENTIAL_INTERVALS
		-- reference function to make delimited list from `separator'
		local
			previous_lower, previous_upper, lower, upper: INTEGER
			index_list: LIST [INTEGER]
		do
			String_32_searcher.initialize_deltas (separator)
			index_list := String_32_searcher.substring_index_list_with_deltas (a_text, separator, 1, a_text.count)
			create Result.make (index_list.count + 1)
			across index_list as list loop
				lower := list.item; upper := list.item + separator.count - 1
				previous_lower := previous_upper + 1
				previous_upper := lower - 1
				Result.extend (previous_lower, previous_upper)
				previous_upper := upper
			end
			Result.extend (upper + 1, a_text.count)
		end

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

feature {NONE} -- Internal attributes

	test: EL_EQA_TEST_SET

feature {NONE} -- Constants

	Extension_routines: EL_STRING_8_LIST
		once
			Result := "append, prepend"
		end

	Pruning_routines: EL_STRING_8_LIST
		once
			Result := "adjust, left_adjust, prune_leading, prune_trailing, right_right"
		end

end