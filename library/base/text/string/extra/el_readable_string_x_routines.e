note
	description: "[
		Routines to supplement handling of strings conforming to
		${READABLE_STRING_8} and ${READABLE_STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 23:24:50 GMT (Tuesday 8th April 2025)"
	revision: "63"

deferred class
	EL_READABLE_STRING_X_ROUTINES [
		READABLE_STRING_X -> READABLE_STRING_GENERAL, C -> COMPARABLE -- CHARACTER_X
	]

inherit
	EL_READABLE_STRING_X_ROUTINES_BASE [READABLE_STRING_X, C]

feature -- Access

	occurrence_intervals (
		target: READABLE_STRING_X; pattern: READABLE_STRING_GENERAL; keep_ref: BOOLEAN

	): EL_OCCURRENCE_INTERVALS
		do
			Result := Once_occurence_intervals.emptied
			fill_intervals (Result, target, pattern)
			if keep_ref then
				Result := Result.twin
			end
		end

	selected (n: INTEGER; n_set: READABLE_INDEXABLE [INTEGER]; name_list: READABLE_STRING_X): READABLE_STRING_X
		require
			name_count_matches: n_set.upper - n_set.lower = name_list.occurrences (',')
		local
			index, i, start_index, end_index: INTEGER; found: BOOLEAN
		do
			if name_list.count = 0 then
				Result := name_list.substring (1, 0)
			else
				from index := n_set.lower until index > n_set.upper or found loop
					if n_set [index] = n then
						found := True
					else
						index := index + 1
					end
				end
				if found and then attached split_on_character (name_list, ',') as split_list then
					found := False
					i := n_set.lower
					across split_list as list until found loop
						if i = index then
							start_index := list.item_lower; end_index := list.item_upper
							if name_list [start_index] = ' ' then
								start_index :=  start_index + 1
							end
							found := True
						else
							i := i + 1
						end
					end
					if found then
						Result := name_list.substring (start_index, end_index)
					else
						Result := name_list.substring (1, 0)
					end
				else
					Result := name_list.substring (1, 0)
				end
			end
		end

	split_intervals (target: READABLE_STRING_X; separator: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): EL_SPLIT_INTERVALS
		do
			Result := Once_split_intervals.emptied
			fill_intervals (Result, target, separator)
			if keep_ref then
				Result := Result.twin
			end
		end

	to_utf_8 (a_str: READABLE_STRING_X): STRING
		do
			if attached extended_string (a_str) as str then
				create Result.make (str.utf_8_byte_count)
				str.append_to_utf_8 (Result)
			end
		end

feature -- Measurement

	between_interval (str: READABLE_STRING_X; left, right: CHARACTER_32): INTEGER_64
		-- compact substring interval between `left' and `right' character
		local
			left_index, right_index: INTEGER; ir: EL_INTERVAL_ROUTINES
		do
			left_index := index_of (str, left, 1)
			if left_index > 0 then
				right_index := last_index_of (str, right, str.count)
				if right_index > 0 then
					Result := ir.compact (left_index + 1, right_index - 1)
				end
			end
		end

feature -- Lists

	delimited_list (text: READABLE_STRING_X; delimiter: READABLE_STRING_GENERAL): like substring_list
		-- `text' split into arrayed list by `delimiter' string
		do
			Result := substring_list (text, split_intervals (text, delimiter, False))
		end

	to_csv_list (text: READABLE_STRING_X): like to_list
		-- left adjusted comma separated list
		do
			Result := to_list (text, ',', {EL_SIDE}.Left)
		end

	to_list (text: READABLE_STRING_X; uc: CHARACTER_32; adjustments: INTEGER): like substring_list
		-- `text' split by `uc' character and space adjusted according to `adjustments':
		-- `Both', `Left', `None', `Right' from class `EL_SIDE'.
		require
			valid_adjustments: valid_adjustments (adjustments)
		do
			if attached Once_split_intervals.emptied as intervals then
				intervals.fill (text, uc, adjustments)
				Result := substring_list (text, intervals)
			end
		end

feature -- Character query

	has_enclosing (s: READABLE_STRING_X; c_first, c_last: CHARACTER_32): BOOLEAN
			--
		deferred
		end

feature -- Status query

	has_member (str: READABLE_STRING_X; set: EL_SET [C]): BOOLEAN
		-- `True' if at least one character in `str' is a member of `set'
		do
			Result := extended_string (str).has_member (set)
		end

	is_eiffel (str: READABLE_STRING_X): BOOLEAN
		-- `True' if `str' is an Eiffel identifier
		do
			Result := extended_string (str).is_eiffel
		end

	is_identifier_boundary (str: READABLE_STRING_X; lower, upper: INTEGER): BOOLEAN
		-- `True' if indices `lower' to `upper' are an identifier boundary
		require
			valid_lower: lower >= 1
			valid_upper: upper <= str.count
		do
			Result := True
			if upper + 1 <= str.count then
				Result := not is_i_th_identifier (str, upper + 1)
			end
			if Result and then lower - 1 >= 1 then
				Result := not is_i_th_identifier (str, lower - 1)
			end
		end

	is_subset_of (str: READABLE_STRING_X; set: EL_SET [C]): BOOLEAN
		-- `True' if set of all characters in `str' is a subset of `set'
		deferred
		end

feature -- Comparison

	caseless_ends_with (big, small: READABLE_STRING_X): BOOLEAN
		-- `True' if `big.ends_with (small)' is true regardless of case of `small'
		do
			if small.is_empty then
				Result := True

			elseif big.count >= small.count then
				Result := occurs_caseless_at (big, small, big.count - small.count + 1)
			end
		end

	occurs_at (big, small: READABLE_STRING_X; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index'
		deferred
		end

	occurs_caseless_at (big, small: READABLE_STRING_X; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index' regardless of case
		deferred
		end

	same_caseless (a, b: READABLE_STRING_X): BOOLEAN
		-- `True' `a' and `b' are the same regardless of case
		do
			if a.count = b.count then
				Result := occurs_caseless_at (a, b, 1)
			end
		end

feature -- Substring

	adjusted (str: READABLE_STRING_X): READABLE_STRING_X
		local
			start_index, end_index: INTEGER
		do
			end_index := str.count - extended_string (str).trailing_white_count
			if end_index.to_boolean then
				start_index := extended_string (str).leading_white_count + 1
			else
				start_index := 1
			end
			if start_index = 1 and then end_index = str.count then
				Result := str
			else
				Result := str.substring (start_index, end_index)
			end
		end

	bracketed (str: READABLE_STRING_X; left_bracket: CHARACTER_32): READABLE_STRING_X
		-- first substring of `str' enclosed by one of matching paired characters: {}, [], (), <>
		-- Empty string if `not str.has (left_bracket)' or no matching right bracket
		do
			Result := new_bracketed (str, left_bracket, False)
		end

	bracketed_last (str: READABLE_STRING_X; left_bracket: CHARACTER_32): READABLE_STRING_X
		-- last substring of `str' enclosed by one of matching paired characters: {}, [], (), <>
		-- Empty string if `not str.has (left_bracket)' or no matching right bracket
		do
			Result := new_bracketed (str, left_bracket, True)
		end

	curtailed (str: READABLE_STRING_X; max_count: INTEGER): READABLE_STRING_X
		-- `str' curtailed to `max_count' with added ellipsis where `max_count' is exceeded
		do
			if str.count > max_count - 2 then
				Result := str.substring (1, max_count - 2) + Character_string_8_table.item ('.', 2)
			else
				Result := str
			end
		end

	sandwiched_parts (str: READABLE_STRING_X; separator: CHARACTER_32; head_count, tail_count: INTEGER): READABLE_STRING_X
		-- joined substring of split list defined by `separator' after `head_count' and `tail_count' parts
		-- have been removed from head and tail of list respectively
		local
			start_index, end_index, index, first_cursor_index, last_cursor_index: INTEGER
		do
			if head_count + tail_count > 0 then
				if attached split_on_character (str, separator) as split_list then
					first_cursor_index := head_count + 1
					last_cursor_index := split_list.count - tail_count

					across split_list as list loop
						index := list.cursor_index
						if index = first_cursor_index then
							start_index := list.item_lower
						end
						if index = last_cursor_index then
							end_index := list.item_upper
						end
					end
					if start_index > 0 and end_index > 0 then
						Result := str.substring (start_index, end_index)
					else
						Result := str.substring (1, 0)
					end
				end
			else
				Result := str
			end
		end

	substring_to (str: READABLE_STRING_X; uc: CHARACTER_32): READABLE_STRING_X
		-- `substring_to_from' from start of string
		do
			Result := substring_to_from (str, uc, null)
		end

	substring_to_from (str: READABLE_STRING_X; uc: CHARACTER_32; start_index_ptr: TYPED_POINTER [INTEGER]): READABLE_STRING_X
		-- substring from INTEGER at memory location `start_index_ptr' up to but not including index of `uc'
		-- or else `substring_end (start_index)' if `uc' not found
		-- `start_index' is 1 if `start_index_ptr = Default_pointer'
		-- write new start_index back to `start_index_ptr'
		-- if `uc' not found then new `start_index' is `count + 1'
		local
			start_index, index: INTEGER; pointer: EL_POINTER_ROUTINES
		do
			if start_index_ptr.is_default_pointer then
				start_index := 1
			else
				start_index := pointer.read_integer_32 (start_index_ptr)
			end
			index := index_of (str, uc, start_index)
			if index > 0 then
				Result := str.substring (start_index, index - 1)
				start_index := index + 1
			else
				Result := str.substring (start_index, str.count)
				start_index := str.count + 1
			end
			if not start_index_ptr.is_default_pointer then
				start_index_ptr.memory_copy ($start_index, {PLATFORM}.Integer_32_bytes)
			end
		end

	substring_to_reversed (str: READABLE_STRING_X; uc: CHARACTER_32): READABLE_STRING_X
		-- `substring_to_reversed_from' from end of string
		do
			Result := substring_to_reversed_from (str, uc, null)
		end

	substring_to_reversed_from (
		str: READABLE_STRING_X; uc: CHARACTER_32; start_index_from_end_ptr: TYPED_POINTER [INTEGER]
	): READABLE_STRING_X
		-- the same as `substring_to' except going from right to left
		-- if `uc' not found `start_index_from_end' is set to `0' and written back to `start_index_from_end_ptr'
		local
			start_index_from_end, index: INTEGER; pointer: EL_POINTER_ROUTINES
		do
			if start_index_from_end_ptr.is_default_pointer then
				start_index_from_end := str.count
			else
				start_index_from_end := pointer.read_integer_32 (start_index_from_end_ptr)
			end
			index := last_index_of (str, uc, start_index_from_end)
			if index > 0 then
				Result := str.substring (index + 1, start_index_from_end)
				start_index_from_end := index - 1
			else
				Result := str.substring (1, start_index_from_end)
				start_index_from_end := 0
			end
			if not start_index_from_end_ptr.is_default_pointer then
				pointer.put_integer_32 (start_index_from_end, start_index_from_end_ptr)
			end
		end

	truncated (str: READABLE_STRING_X; max_count: INTEGER): READABLE_STRING_X
		-- return `str' truncated to `max_count' characters, adding ellipsis where necessary
		do
			if str.count <= max_count then
				Result := str
			else
				Result := str.substring (1, max_count - 2) + Character_string_8_table.item ('.', 2)
			end
		end

end