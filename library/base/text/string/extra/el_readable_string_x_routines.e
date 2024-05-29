note
	description: "[
		Routines to supplement handling of strings conforming to
		${READABLE_STRING_8} and ${READABLE_STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-29 10:37:11 GMT (Wednesday 29th May 2024)"
	revision: "38"

deferred class
	EL_READABLE_STRING_X_ROUTINES [
		READABLE_STRING_X -> READABLE_STRING_GENERAL, C -> COMPARABLE -- CHARACTER_X
	]

inherit
	EL_READABLE_STRING_GENERAL_ROUTINES_IMP

	EL_STRING_GENERAL_ROUTINES
		rename
			to_unicode_general as to_unicode,
			String_searcher as ZString_searcher
		export
			{ANY} as_zstring, new_zstring, to_unicode
		end

	EL_STRING_BIT_COUNTABLE [READABLE_STRING_X]

	STRING_HANDLER

	EL_STRING_8_CONSTANTS

	EL_SIDE_ROUTINES
		rename
			valid_sides as valid_adjustments
		export
			{ANY} valid_adjustments
		end

feature -- Access

	occurrence_intervals (target: READABLE_STRING_X; pattern: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): EL_OCCURRENCE_INTERVALS
		do
			Result := Once_occurence_intervals.emptied
			fill_intervals (Result, target, pattern)
			if keep_ref then
				Result := Result.twin
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

	selected (n: INTEGER; n_set: ARRAY [INTEGER]; name_list: READABLE_STRING_X): READABLE_STRING_X
		require
			name_count_matches: n_set.count = name_list.occurrences (',') + 1
		local
			index: INTEGER; found: BOOLEAN
		do
			if name_list.count = 0 then
				Result := name_list
			else
				from index := 1 until index > n_set.count or found loop
					if n_set [index] = n then
						found := True
					else
						index := index + 1
					end
				end
				if found then
					if attached name_list.split (',') as list then
						if list.valid_index (index) then
							Result := list [index]
							if Result.count > 0 and then Result [1] = ' ' then
								Result := Result.substring (2, Result.count)
							end
						else
							Result := name_list.substring (1, 0)
						end
					end
				else
					Result := name_list.substring (1, 0)
				end
			end
		end

feature -- Lists

	delimited_list (text: READABLE_STRING_X; delimiter: READABLE_STRING_GENERAL): EL_ARRAYED_LIST [READABLE_STRING_X]
		-- `text' split into arrayed list by `delimiter' string
		do
			Result := substring_list (text, split_intervals (text, delimiter, False))
		end

	to_csv_list (text: READABLE_STRING_X): like to_list
		-- left adjusted comma separated list
		do
			Result := to_list (text, ',', {EL_SIDE}.Left)
		end

	to_list (text: READABLE_STRING_X; uc: CHARACTER_32; adjustments: INTEGER): EL_ARRAYED_LIST [READABLE_STRING_X]
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

feature -- Status query

	has_double_quotes (s: READABLE_STRING_X): BOOLEAN
			--
		do
			Result := has_quotes (s, 2)
		end

	has_enclosing (s: READABLE_STRING_X; c_first, c_last: CHARACTER_32): BOOLEAN
			--
		deferred
		end

	has_quotes (s: READABLE_STRING_X; type: INTEGER): BOOLEAN
		require
			double_or_single: 1 <= type and type <= 2
		do
			if type = 1 then
				Result := has_enclosing (s, '%'', '%'')
			else
				Result := has_enclosing (s, '"', '"')
			end
		end

	has_single_quotes (s: READABLE_STRING_X): BOOLEAN
			--
		do
			Result := has_quotes (s, 1)
		end

	is_eiffel (s: READABLE_STRING_X): BOOLEAN
		-- `True' if `target' is an Eiffel identifier
		do
			Result := cursor (s).is_eiffel
		end

	is_eiffel_lower (s: READABLE_STRING_X): BOOLEAN
		-- `True' if `target' is a lower-case Eiffel identifier
		do
			Result := cursor (s).is_eiffel_lower
		end

	is_eiffel_upper (s: READABLE_STRING_X): BOOLEAN
		-- `True' if `target' is an upper-case Eiffel identifier
		do
			Result := cursor (s).is_eiffel_upper
		end

	is_identifier_boundary (str: READABLE_STRING_X; lower, upper: INTEGER): BOOLEAN
		-- `True' if indices `lower' to `upper' are an identifier boundary
		require
			valid_lower: lower >= 1
			valid_upper: upper <= str.count
		do
			Result := True
			if upper + 1 <= str.count then
				Result := not is_identifier_character (str, upper + 1)
			end
			if Result and then lower - 1 >= 1 then
				Result := not is_identifier_character (str, lower - 1)
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

	same_strings (a, b: READABLE_STRING_X): BOOLEAN
		deferred
		end

feature -- Character query

	is_identifier_character (str: READABLE_STRING_X; i: INTEGER): BOOLEAN
		deferred
		end

feature -- Substring

	adjusted (str: READABLE_STRING_X): READABLE_STRING_X
		local
			start_index, end_index: INTEGER
		do
			end_index := str.count - cursor (str).trailing_white_count
			if end_index.to_boolean then
				start_index := cursor (str).leading_white_count + 1
			else
				start_index := 1
			end
			if start_index = 1 and then end_index = str.count then
				Result := str
			else
				Result := str.substring (start_index, end_index)
			end
		end

	sandwiched_parts (str: READABLE_STRING_X; separator: CHARACTER_32; head_count, tail_count: INTEGER): READABLE_STRING_X
		-- joined substring of split list defined by `separator' after `head_count' and `tail_count' parts
		-- have been removed from head and tail of list respectively
		local
			start_index, end_index, index, first_cursor_index, last_cursor_index: INTEGER
		do
			if head_count + tail_count > 0 then
				if attached split_on_character as split_list then
					split_list.set_target (str); split_list.set_separator (separator)

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
			index := str.index_of (uc, start_index)
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

feature {NONE} -- Implementation

	null: TYPED_POINTER [INTEGER]
		do
		end

	substring_list (text: READABLE_STRING_X; intervals: EL_SEQUENTIAL_INTERVALS): like to_list
		do
			create Result.make (intervals.count)
			from intervals.start until intervals.after loop
				Result.extend (text.substring (intervals.item_lower, intervals.item_upper))
				intervals.forth
			end
		end

	to_code (character: CHARACTER_32): NATURAL_32
		do
			Result := character.natural_32_code
		end

feature {NONE} -- Deferred

	cursor (s: READABLE_STRING_X): EL_STRING_ITERATION_CURSOR
		deferred
		end

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: READABLE_STRING_X; pattern: READABLE_STRING_GENERAL)
		deferred
		end

	last_index_of (str: READABLE_STRING_X; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		deferred
		end

	split_on_character: EL_SPLIT_ON_CHARACTER [READABLE_STRING_X]
		deferred
		end

	string_searcher: STRING_SEARCHER
		deferred
		end

feature {NONE} -- Constants

	Once_occurence_intervals: EL_OCCURRENCE_INTERVALS
		once
			create Result.make_empty
		end

	Once_split_intervals: EL_SPLIT_INTERVALS
		once
			create Result.make_empty
		end

end