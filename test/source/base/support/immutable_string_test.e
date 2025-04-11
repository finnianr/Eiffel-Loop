note
	description: "[
		Same as ${STRING_TEST} but with shared immutable substrings
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-11 17:52:41 GMT (Friday 11th April 2025)"
	revision: "28"

class
	IMMUTABLE_STRING_TEST

inherit
	STRING_TEST
		redefine
			s_8_substring, s_32_substring, set, set_substrings,
			new_general_list, new_split_list_array, split_intervals
		end

	EL_SHARED_IMMUTABLE_8_MANAGER
		rename
			Immutable_8 as Immutable_manager_8
		end

	EL_SHARED_IMMUTABLE_32_MANAGER
		rename
			Immutable_32 as Immutable_manager_32
		end

create
	make, make_empty

feature -- Strings

	s_32_substring: IMMUTABLE_STRING_32

	s_8_substring: detachable IMMUTABLE_STRING_8

	immutable_32: IMMUTABLE_STRING_32

	immutable_8: detachable IMMUTABLE_STRING_8

feature -- Element change

	set (str_32: STRING_32)
		do
			Precursor (str_32)
			Immutable_manager_32.set_item (str_32.area, 0, str_32.count)
			immutable_32 := Immutable_manager_32.item.twin

			if s_32.is_valid_as_string_8 and then attached s_32.to_string_8 as str_8 then
				Immutable_manager_8.set_item (str_8.area, 0, str_8.count)
				immutable_8 := Immutable_manager_8.item.twin
			else
				immutable_8 := Void
			end
		ensure then
			same_s_32: s_32.same_string (immutable_32)
			same_s_8: attached s_8 as str_8 implies str_8.same_string (immutable_8)
		end

	set_substrings (start_index, end_index: INTEGER)
		do
			s_32_substring := immutable_32.shared_substring (start_index, end_index)

			create zs_substring.make_from_string (s_32_substring)
			if attached immutable_8 as str_8 then
				s_8_substring := str_8.shared_substring (start_index, end_index)
			else
				s_8_substring := Void
			end
		end

feature -- Test comparisons

	split_intervals: BOOLEAN
		local
			intervals_s_32: EL_SEQUENTIAL_INTERVALS; s: EL_STRING_32_ROUTINES
			intervals_list: ARRAYED_LIST [EL_OCCURRENCE_INTERVALS]
		do
			intervals_s_32 := s.split_intervals (s_32, s_32_substring, True)

			create intervals_list.make_from_array (<<
				create {EL_SPLIT_INTERVALS}.make_by_string (s_32, s_32_substring)
			>>)
			Result := across intervals_list as list all list.item.same_as (intervals_s_32) end
		end

feature -- Extended ZSTRING

	is_ascii (substring_is_ascii: BOOLEAN)
		do
			across new_general_substring_list as list loop
				test.assert ("methods agree", substring_is_ascii = super_readable_general (list.item).is_ascii)
			end
		end

	append_substring_to_string_32 (a_value: STRING_32; intervals: EL_SPLIT_INTERVALS)
		-- EL_EXTENDED_READABLE_ZSTRING.append_substring_to_string_32
		local
			value: STRING_32; start_index, end_index: INTEGER_32
		do
			value := a_value.substring (1, 3)
			across new_general_list as list loop
				if attached list.item as general then
					value.keep_head (3)
					start_index := intervals.item_lower; end_index := intervals.item_upper
					super_readable_general (general).append_substring_to_string_32 (value, start_index, end_index)
					test.assert ("same appended strings", value ~ a_value)
				end
			end
		end

	append_substring_to_string_8 (a_value: STRING_8; intervals: EL_SPLIT_INTERVALS)
		-- EL_EXTENDED_READABLE_ZSTRING.append_substring_to_string_8
		local
			value: STRING_8; start_index, end_index: INTEGER_32
		do
			value := a_value.substring (1, 3)
			across new_general_list as list loop
				if attached list.item as general then
					value.keep_head (3)
					start_index := intervals.item_lower; end_index := intervals.item_upper
					super_readable_general (general).append_substring_to_string_8 (value, start_index, end_index)
					test.assert ("same appended strings", value ~ a_value)
				end
			end
		end

	is_ascii_substring (intervals: EL_SPLIT_INTERVALS; is_ascii_interval: BOOLEAN)
		-- EL_EXTENDED_READABLE_ZSTRING.append_substring_to_string_8
		local
			start_index, end_index: INTEGER_32; l_result: BOOLEAN
		do
			across new_general_list as list loop
				start_index := intervals.item_lower; end_index := intervals.item_upper
				if attached super_readable_general (list.item) as general then
					l_result := general.is_ascii_substring (start_index, end_index)
				end
				test.assert ("methods agree", l_result = is_ascii_interval)
			end
		end

feature {NONE} -- Implementation

	new_general_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
		do
			Result := Precursor
			Result.extend (immutable_32)
			if attached immutable_8 as str_8 then
				Result.extend (str_8)
			end
		end

	new_split_list_array: ARRAYED_LIST [EL_SPLIT_READABLE_STRING_LIST [READABLE_STRING_GENERAL]]
		do
			create Result.make_from_array (<<
				create {EL_SPLIT_IMMUTABLE_STRING_32_LIST}.make_shared_by_string (s_32, s_32_substring)
			>>)
			if attached s_8_substring as str_8 then
				if attached s_8 as target_8 then
					Result.extend (create {EL_SPLIT_IMMUTABLE_STRING_8_LIST}.make_shared_by_string (target_8, str_8))
				end
			end
		end
end