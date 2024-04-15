note
	description: "[
		Fields and implementation for class ${STRING_TEST}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-15 7:56:36 GMT (Monday 15th April 2024)"
	revision: "26"

class
	STRING_TEST_FIELDS

inherit
	ANY

	EL_SHARED_TEST_TEXT

	EL_STRING_32_CONSTANTS

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
		local
			s: EL_STRING_32_ROUTINES
		do
			s.replace_character (s_32, Text.Euro_symbol, '¤')
			s_32_action.apply
			s.replace_character (s_32, '¤', Text.Euro_symbol)
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

	new_occurrence_intervals (target, pattern: STRING_32): EL_SEQUENTIAL_INTERVALS
		local
			index_list: LIST [INTEGER]
		do
			String_32_searcher.initialize_deltas (pattern)
			index_list := String_32_searcher.substring_index_list_with_deltas (target, pattern, 1, target.count)
			create Result.make (index_list.count)
			across index_list as list loop
				Result.extend (list.item, list.item + pattern.count - 1)
			end
		end

	new_split_intervals (target, separator: STRING_32): EL_SEQUENTIAL_INTERVALS
		local
			previous_lower, previous_upper, lower, upper: INTEGER
			index_list: LIST [INTEGER]
		do
			String_32_searcher.initialize_deltas (separator)
			index_list := String_32_searcher.substring_index_list_with_deltas (target, separator, 1, target.count)
			create Result.make (index_list.count + 1)
			across index_list as list loop
				lower := list.item; upper := list.item + separator.count - 1
				previous_lower := previous_upper + 1
				previous_upper := lower - 1
				Result.extend (previous_lower, previous_upper)
				previous_upper := upper
			end
			Result.extend (upper + 1, target.count)
		end

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