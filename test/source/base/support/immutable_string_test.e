note
	description: "[
		Same as [$source STRING_TEST] but with shared immutable substrings
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-06 14:41:48 GMT (Sunday 6th August 2023)"
	revision: "23"

class
	IMMUTABLE_STRING_TEST

inherit
	STRING_TEST
		redefine
			s_8_substring, s_32_substring, set, set_substrings, new_split_list_array, split_intervals
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
	default_create, make, make_filled

convert
	make ({STRING_32})

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
			intervals_s_32 := s.split_intervals (s_32, s_32_substring)

			create intervals_list.make_from_array (<<
				create {EL_SPLIT_INTERVALS}.make_by_string (s_32, s_32_substring)
			>>)
			Result := across intervals_list as list all list.item.same_as (intervals_s_32) end
		end

feature {NONE} -- Implementation

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