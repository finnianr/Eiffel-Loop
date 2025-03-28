note
	description: "[
		Routines to supplement handling of strings conforming to
		${READABLE_STRING_8} and ${READABLE_STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 15:51:48 GMT (Saturday 29th March 2025)"
	revision: "53"

deferred class
	EL_READABLE_STRING_X_ROUTINES [
		READABLE_STRING_X -> READABLE_STRING_GENERAL, C -> COMPARABLE -- CHARACTER_X
	]

inherit
	EL_CASE
		rename
			is_valid as is_valid_case,
			Upper as Upper_case,
			Lower as Lower_case
		export
			{NONE} all
		end

	EL_READABLE_STRING_GENERAL_ROUTINES_IMP

	EL_STRING_GENERAL_ROUTINES
		rename
			to_unicode_general as to_unicode
		export
			{ANY} as_zstring, ZSTRING, to_unicode
		end

	EL_STRING_BIT_COUNTABLE [READABLE_STRING_X]

	EL_STRING_8_CONSTANTS

	EL_SIDE_ROUTINES
		rename
			valid_sides as valid_adjustments
		export
			{ANY} valid_adjustments
		end

	EL_ZSTRING_CONSTANTS
		rename
			String_searcher as ZString_searcher
		end

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

	split_intervals (target: READABLE_STRING_X; separator: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): EL_SPLIT_INTERVALS
		do
			Result := Once_split_intervals.emptied
			fill_intervals (Result, target, separator)
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

	to_utf_8 (str: READABLE_STRING_X): STRING
		do
			if attached cursor (str) as c then
				create Result.make (c.utf_8_byte_count)
				c.append_to_utf_8 (Result)
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

	word_count (str: READABLE_STRING_X; exclude_variable_references: BOOLEAN): INTEGER
		-- count of all substrings of `str' that are separated by whitespace
		-- but if `exclude_variable_references' is `True', substract cound of substrings
		-- that are variable references defined by `is_variable_reference'
		local
			i, upper, word_index: INTEGER; state_find_word: BOOLEAN; c32: EL_CHARACTER_32_ROUTINES
		do
			upper := str.count
			state_find_word := True
			from i := 1 until i > upper loop
				if state_find_word then
					from until i > upper or else not c32.is_space (str [i]) loop
						i := i + 1
					end
					word_index := i
				else
					from until i > upper or else c32.is_space (str [i]) loop
						i := i + 1
					end
					if attached new_shared_substring (str, word_index, i - 1) as word
						and then has_alpha (word)
						and then exclude_variable_references implies not is_variable_reference (word)
					then
						Result := Result + 1
					end
				end
				state_find_word := not state_find_word
				i := i + 1
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

feature -- Character query

	ends_with_character (s: READABLE_STRING_x; c: C): BOOLEAN
		deferred
		end

	has_alpha (str: READABLE_STRING_X): BOOLEAN
		local
			i, upper: INTEGER
		do
			upper := str.count
			from i := 1 until Result or else i > upper loop
				Result := is_i_th_alpha (str, i)
				i := i + 1
			end
		end

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

	starts_with_character (s: READABLE_STRING_x; c: C): BOOLEAN
		deferred
		end

feature -- Status query

	has_member (str: READABLE_STRING_X; set: EL_SET [C]): BOOLEAN
		-- `True' if at least one character in `str' is a member of `set'
		deferred
		end

	is_alpha_numeric (str: READABLE_STRING_X): BOOLEAN
		-- `True' if `target' is an Eiffel identifier
		do
			Result := cursor (str).all_alpha_numeric
		end

	is_canonically_spaced (s: READABLE_STRING_X): BOOLEAN
		-- `True' if the longest substring of whitespace consists of one space character (ASCII 32)
		local
			uc_i: CHARACTER_32; i, upper, space_count: INTEGER
			c32: EL_CHARACTER_32_ROUTINES
		do
			Result := True; upper := s.count
			from i := 1 until not Result or else i > upper loop
				uc_i := s [i]
				if c32.is_space (uc_i) then
					space_count := space_count + 1
				else
					space_count := 0
				end
				inspect space_count
					when 0 then
						do_nothing
					when 1 then
						Result := uc_i = ' '
				else
					Result := False
				end
				i := i + 1
			end
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

	is_variable_name (str: READABLE_STRING_X): BOOLEAN
		local
			i, upper: INTEGER
		do
			upper := str.count
			Result := upper > 1
			from i := 1 until not Result or i > upper loop
				inspect i
					when 1 then
						Result := str [i] = '$'
					when 2 then
						Result := is_i_th_alpha (str, i)
				else
					Result := is_i_th_alpha_numeric (str, i) or else str [i] = '_'
				end
				i := i + 1
			end
		end

	is_variable_reference (str: READABLE_STRING_X): BOOLEAN
		-- `True' if str is one of two variable reference forms

		-- 1. $<C identifier>
		-- 2. ${<C identifier>}
		local
			lower, upper, i: INTEGER
		do
			upper := str.count
			if str.count >= 2 and then str [1] = '$' then
				if str [2] = '{' and then upper > 3 then
				-- like: ${name}
					if str [upper] = '}' then
						lower := 3; upper := upper - 1
					end
				else
					lower := 2
				end
				if str.valid_index (lower) then
					Result := is_i_th_alpha (str, lower)
					from i := lower until i > upper or not Result loop
						Result := is_i_th_alpha_numeric (str, i) or else str [i] = '_'
						i := i + 1
					end
				end
			end
		end

	valid_substring_indices (str: READABLE_STRING_X; start_index, end_index: INTEGER): BOOLEAN
		do
			if str.valid_index (start_index) then
				Result := end_index >= start_index - 1 and end_index <= str.count
			end
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

	matches_wildcard (s, wildcard: READABLE_STRING_X): BOOLEAN
		-- try to match `wildcard' search term against string `s' with an asterisk either to the left,
		-- to the right or on both sides
		local
			any_ending, any_start: BOOLEAN; start_index, end_index: INTEGER
			search_string: READABLE_STRING_X
		do
			start_index := 1; end_index := wildcard.count
			inspect wildcard.count
				when 0 then
				when 1 then
					if wildcard [1].code = {ASCII}.Star then
						any_ending := True; any_start := True
					end
			else
				if ends_with_character (wildcard, asterisk)  then
					end_index := end_index - 1
					any_ending := True
				end
				if starts_with_character (wildcard, asterisk) then
					start_index := start_index + 1
					any_start := True
				end
			end
			if start_index - end_index + 1 = wildcard.count then
				search_string := wildcard
			else
				search_string := new_shared_substring (wildcard, start_index, end_index)
			end
			if any_ending and any_start then
				if wildcard.count = 1 then
					Result := True
				else
					Result := s.has_substring (search_string)
				end

			elseif any_ending then
				Result := starts_with (s, search_string)

			elseif any_start then
				Result := ends_with (s, search_string)
			else
				Result := same_string (s, wildcard)
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

feature {NONE} -- Implementation

	new_bracketed (str: READABLE_STRING_X; left_bracket: CHARACTER_32; right_to_left: BOOLEAN): READABLE_STRING_X
		-- substring of `str' enclosed by one of matching paired characters: {}, [], (), <>
		-- Empty string if `not str.has (left_bracket)' or no matching right bracket
		require
			valid_left_bracket: (create {EL_CHARACTER_32_ROUTINES}).is_left_bracket (left_bracket)
		local
			left_index, right_index: INTEGER; c32: EL_CHARACTER_32_ROUTINES
		do
			if right_to_left then
				left_index := last_index_of (str, left_bracket, str.count)
			else
				left_index := index_of (str, left_bracket, 1)
			end
			if left_index > 0 and then attached cursor (str) as l_cursor then
				right_index := index_of (str, c32.right_bracket (left_bracket), left_index + 1)
				right_index := l_cursor.matching_bracket_index (left_index)
				if right_index > 0 then
					Result := str.substring (left_index + 1, right_index - 1)
				else
					Result := str.substring (1, 0)
				end
			else
				Result := str.substring (1, 0)
			end
		end

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

	asterisk: C
		deferred
		end

	as_canonically_spaced (s: READABLE_STRING_X): READABLE_STRING_X
		-- copy of `s' with each substring of whitespace consisting of one space character (ASCII 32)
		deferred
		end

	cursor (s: READABLE_STRING_X): EL_STRING_ITERATION_CURSOR
		deferred
		end

	ends_with (s, trailing: READABLE_STRING_X): BOOLEAN
		deferred
		end

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: READABLE_STRING_X; pattern: READABLE_STRING_GENERAL)
		deferred
		end

	is_i_th_alpha (str: READABLE_STRING_X; i: INTEGER): BOOLEAN
		-- `True' if i'th character is alphabetical
		deferred
		end

	is_i_th_alpha_numeric (str: READABLE_STRING_X; i: INTEGER): BOOLEAN
		-- `True' if i'th character is alphabetical or numeric
		deferred
		end

	is_i_th_identifier (str: READABLE_STRING_X; i: INTEGER): BOOLEAN
		-- `True' if i'th character is an identifier
		deferred
		end

	index_of (str: READABLE_STRING_X; c: CHARACTER_32; start_index: INTEGER): INTEGER
		deferred
		end

	last_index_of (str: READABLE_STRING_X; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		deferred
		end

	new_shared_substring (s: READABLE_STRING_X; start_index, end_index: INTEGER): READABLE_STRING_X
		deferred
		end

	same_string (a, b: READABLE_STRING_X): BOOLEAN
		deferred
		end

	split_on_character (str: READABLE_STRING_X; separator: CHARACTER_32): EL_SPLIT_ON_CHARACTER [READABLE_STRING_X]
		deferred
		end

	string_searcher: STRING_SEARCHER
		deferred
		end

	starts_with (s, leading: READABLE_STRING_X): BOOLEAN
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