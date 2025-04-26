note
	description: "Extends the features of strings conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-26 8:04:56 GMT (Saturday 26th April 2025)"
	revision: "17"

deferred class
	EL_EXTENDED_READABLE_STRING_I [CHAR -> COMPARABLE]

inherit
	EL_EXTENDED_READABLE_STRING_BASE_I [CHAR]
		export
			{STRING_HANDLER} area, index_lower, index_upper
		end

feature -- Access

	adjusted_substring: like target
		-- substring of target without leading and trailing whitespace
		local
			start_index, end_index: INTEGER
		do
			end_index := count - trailing_white_count
			if end_index.to_boolean then
				start_index := leading_white_count + 1
			else
				start_index := 1
			end
			if start_index = 1 and then end_index = count then
				Result := target

			elseif target.is_immutable and then attached {IMMUTABLE_STRING_GENERAL} target as immutable then
				Result := shared_substring (immutable, start_index, end_index)
			else
				Result := target.substring (start_index, end_index)
			end
		end

	filter (included: PREDICATE [CHAR]; output: INDEXABLE [CHAR, INTEGER])
		local
			i, i_upper: INTEGER; c: CHAR
		do
			if attached area as l_area then
				i_upper := index_upper
				from i := index_lower until i > i_upper loop
					c := l_area [i]
					if included (c) then
						output.extend (c)
					end
					i := i + 1
				end
			end
			if attached {RESIZABLE [CHAR]} output as resizable then
				resizable.trim
			end
		end

	bracketed (left_bracket: CHAR): like target
		-- first substring of enclosed by one of matching paired characters: {}, [], (), <>
		-- Empty string if `not has (left_bracket)' or no matching right bracket
		do
			Result := bracketed_substring (left_bracket, False)
		end

	bracketed_last (left_bracket: CHAR): like target
		-- last substring of enclosed by one of matching paired characters: {}, [], (), <>
		-- Empty string if `not str.has (left_bracket)' or no matching right bracket
		do
			Result := bracketed_substring (left_bracket, True)
		end

	selected_substring (n: INTEGER; n_set: READABLE_INDEXABLE [INTEGER]): like target
		require
			name_count_matches: n_set.upper - n_set.lower = occurrences (to_char (','))
		local
			index, i, start_index, end_index: INTEGER; found: BOOLEAN
		do
			if count > 0 then
				from index := n_set.lower until index > n_set.upper or found loop
					if n_set [index] = n then
						found := True
					else
						index := index + 1
					end
				end
				if found and then attached split (to_char (',')) as split_list then
					found := False
					i := n_set.lower
					if attached area as l_area then
						across split_list as list until found loop
							if i = index then
								start_index := list.item_lower; end_index := list.item_upper
								found := True
							else
								i := i + 1
							end
						end
					end
				end
			end
			if found then
				Result := target.substring (start_index, end_index)
			else
				Result := target.substring (1, 0)
			end
		end

	substring_to (c: CHAR): like target
		-- `substring_to_from' from start of string
		do
			Result := substring_to_from (c, null)
		end

	substring_to_from (c: CHAR; start_index_ptr: TYPED_POINTER [INTEGER]): like target
		-- substring from INTEGER at memory location `start_index_ptr' up to but not including index of `c'
		-- or else `substring_end (start_index)' if `c' not found
		-- `start_index' is 1 if `start_index_ptr = Default_pointer'
		-- write new start_index back to `start_index_ptr'
		-- if `c' not found then new `start_index' is `count + 1'
		local
			start_index, index: INTEGER
		do
			if start_index_ptr.is_default_pointer then
				start_index := 1
			else
				start_index := read_integer_32 (start_index_ptr)
			end
			index := index_of (c, start_index)
			if index > 0 then
				Result := target.substring (start_index, index - 1)
				start_index := index + 1
			else
				Result := target.substring (start_index, count)
				start_index := count + 1
			end
			if not start_index_ptr.is_default_pointer then
				start_index_ptr.memory_copy ($start_index, {PLATFORM}.Integer_32_bytes)
			end
		end

	substring_to_reversed (c: CHAR): like target
		-- `substring_to_reversed_from' from end of string
		do
			Result := substring_to_reversed_from (c, null)
		end

	substring_to_reversed_from (c: CHAR; start_index_from_end_ptr: TYPED_POINTER [INTEGER]): like target
		-- the same as `substring_to' except going from right to left
		-- if `c' not found `start_index_from_end' is set to `0' and written back to `start_index_from_end_ptr'
		local
			start_index_from_end, index: INTEGER
		do
			if start_index_from_end_ptr.is_default_pointer then
				start_index_from_end := count
			else
				start_index_from_end := read_integer_32 (start_index_from_end_ptr)
			end
			index := last_index_of (c, start_index_from_end)
			if index > 0 then
				Result := target.substring (index + 1, start_index_from_end)
				start_index_from_end := index - 1
			else
				Result := target.substring (1, start_index_from_end)
				start_index_from_end := 0
			end
			if not start_index_from_end_ptr.is_default_pointer then
				put_integer_32 (start_index_from_end, start_index_from_end_ptr)
			end
		end

feature -- Measurement

	count: INTEGER
		do
			Result := target.count
		end

	between_interval (left, right: CHAR): INTEGER_64
		-- compact substring interval between first `left' character from the start
		-- and last `right' character from the end.
		local
			left_index, right_index: INTEGER; ir: EL_INTERVAL_ROUTINES
		do
			left_index := index_of (left, 1)
			if left_index > 0 then
				right_index := last_index_of (right, count)
				if right_index > 0 then
					Result := ir.compact (left_index + 1, right_index - 1)
				end
			end
		end

	leading_occurrences (c: CHAR): INTEGER
		local
			i, i_upper: INTEGER
		do
			if attached area as l_area then
				i_upper := index_upper
				from i := index_lower until i > i_upper or else l_area [i] /= c loop
					i := i + 1
				end
				Result := i - index_lower
			end
		end

	leading_white_count: INTEGER
		-- count of leading white space characters
		do
			Result := leading_substring_white_count (1, count)
		end

	leading_substring_white_count (start_index, end_index: INTEGER): INTEGER
		-- count of leading white space characters between `start_index' and `end_index'
		require
			valid_start_end_index: valid_substring_indices (start_index, end_index)
		local
			i, i_lower, i_upper: INTEGER
		do
			if attached area as l_area then
				i_lower := lower_abs (start_index); i_upper := upper_abs (end_index)
				if attached Unicode_property as unicode then
					from i := i_lower until i > i_upper or else not is_i_th_space (l_area, i, unicode) loop
						i := i + 1
					end
				end
				Result := i - i_lower
			end
		end

	matching_bracket_index (index: INTEGER): INTEGER
		require
			valid_index: valid_index (index)
			left_bracket_at_index: is_left_bracket_at (index)
		local
			right_index: INTEGER; left_bracket: CHAR
		do
			left_bracket := to_char (target [index])
			right_index := right_bracket_index (area, left_bracket, index_lower + index, index_upper)
			if right_index > 0 then
				Result := right_index - index_lower + 1
			end
		end

	occurrences (c: CHAR): INTEGER
		do
			Result := occurrences_in_bounds (c, 1, count)
		end

	occurrences_in_bounds (c: CHAR; start_index, end_index: INTEGER): INTEGER
		-- count of `c' occurrences between `start_index' and `end_index'
		do
			if count > 0 then
				Result := occurrences_in_area_bounds (area, c, lower_abs (start_index), upper_abs (end_index))
			end
		end

	trailing_white_count: INTEGER
		local
			i, first_i: INTEGER
		do
			if attached area as l_area then
				first_i := index_lower
				if attached Unicode_property as unicode then
					from i := index_upper until i < first_i or else not is_i_th_space (l_area, i, unicode) loop
						i := i - 1
					end
				end
				Result := index_upper - i
			end
		end

	utf_8_byte_count: INTEGER
		local
			i, upper: INTEGER
		do
			if attached area as l_area then
				from i := index_lower; upper := index_upper until i > upper loop
					Result := Result + code_utf_8_byte_count (to_character_32 (l_area [i]).natural_32_code)
					i := i + 1
				end
			end
		end

	word_count (exclude_variable_references: BOOLEAN): INTEGER
		-- count of all substrings of `str' that are separated by whitespace
		-- but if `exclude_variable_references' is `True', substract count of substrings
		-- that are variable references defined by `is_variable_reference'
		local
			i, i_upper, word_index: INTEGER; state_find_word: BOOLEAN
			word: like new_readable
		do
			word := new_readable
			i_upper := index_upper
			state_find_word := True
			if attached area as l_area and then attached Unicode_property as unicode then
				from i := index_lower until i > i_upper loop
					if state_find_word then
						i := index_of_character_type_change (l_area, i, i_upper, state_find_word, unicode)
						word_index := i
					else
						i := index_of_character_type_change (l_area, i, i_upper, state_find_word, unicode)
						word.set_target (new_shared_substring (target, word_index + 1, i))
						if word.has_alpha then
							if exclude_variable_references implies not word.is_variable_reference then
								Result := Result + 1
							end
						end
					end
					state_find_word := not state_find_word
					i := i + 1
				end
			end
		end

feature -- Character query

	ends_with_character (c: CHAR): BOOLEAN
		do
			Result := index_upper >= index_lower and then area [index_upper] = c
		end

	has_alpha: BOOLEAN
		do
			Result := substring_has_alpha (area, index_lower, index_upper)
		end

	has_character_in_bounds (c: CHAR; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `c' occurs between `start_index' and `end_index'
		require
			valid_start_end_index: valid_substring_indices (start_index, end_index)
		local
			i, i_upper: INTEGER
		do
			if valid_index (start_index) then
				i_upper := upper_abs (end_index)
				if attached area as l_area then
					from i := lower_abs (start_index) until i > i_upper or Result loop
						Result := l_area [i] = c
						i := i + 1
					end
				end
			end
		end

	has_enclosing (c_first, c_last: CHAR): BOOLEAN
			--
		do
			inspect count
				when 0, 1 then
					do_nothing
			else
				if attached area as l_area then
					Result := l_area [index_lower] = c_first and then l_area [index_upper] = c_last
				end
			end
		ensure
			definition: Result implies
				target [1] = to_character_32 (c_first) and target [target.count] = to_character_32 (c_last)
		end

	has_member (set: EL_SET [CHAR]): BOOLEAN
		-- `True' if at least one character in `str' is a member of `set'
		local
			i, upper: INTEGER
		do
			if attached area as l_area then
				from i := index_lower; upper := index_upper until i > upper or Result loop
					Result := set.has (l_area [i])
					i := i + 1
				end
			end
		end

	is_alpha_numeric: BOOLEAN
		-- `True' if all characters in `target' are alphabetical or numerical
		deferred
		end

	is_ascii: BOOLEAN
		-- `True' if all characters in `target' are in the ASCII character set: 0 .. 127
		do
			Result := all_ascii_in_range (area, index_lower, index_upper)
		end

	is_ascii_substring (start_index, end_index: INTEGER): BOOLEAN
		-- `True' if all characters in `target.substring (start_index, end_index)'
		-- are in the ASCII character set: 0 .. 127
		require
			valid_start_end_index: valid_substring_indices (start_index, end_index)
		do
			Result := all_ascii_in_range (area, lower_abs (start_index), upper_abs (end_index))
		end

	is_alpha_numeric_substring (start_index, end_index: INTEGER): BOOLEAN
		-- `True' if all characters in `target.substring (start_index, end_index)' are alpha-numeric
		require
			valid_start_end_index: valid_substring_indices (start_index, end_index)
		do
			Result := all_alpha_numeric_in_range (area, lower_abs (start_index), upper_abs (end_index))
		end

	is_subset_of (set: EL_SET [CHAR]): BOOLEAN
		-- `True' if all characters are a member of `set'
		local
			i, i_upper: INTEGER
		do
			if attached area as l_area then
				i_upper := index_upper; Result := True
				from i := index_lower until i > i_upper or not Result loop
					Result := set.has (l_area [i])
					i := i + 1
				end
			end
		end

	starts_with_character (c: CHAR): BOOLEAN
		do
			Result := index_upper >= index_lower and then area [index_lower] = c
		end

feature -- Status query

	is_canonically_spaced: BOOLEAN
		-- `True' if the longest substring of whitespace consists of one space character (ASCII 32)
		local
			c_i, space: CHAR; i, i_upper, space_count: INTEGER; is_space: BOOLEAN
		do
			space := to_char (' ')
			if attached area as l_area and then attached Unicode_property as unicode then
				Result := True; i_upper := index_upper
				from i := index_lower until not Result or else i > i_upper loop
					c_i := l_area [i]
					is_space := is_i_th_space (l_area, i, unicode)
					if is_space then
						space_count := space_count + 1
					else
						space_count := 0
					end
					inspect space_count
						when 0 then
							do_nothing
						when 1 then
							Result := c_i = space
					else
						Result := False
					end
					i := i + 1
				end
			end
		end

	is_eiffel: BOOLEAN
		-- `True' if `target' is an Eiffel identifier
		do
			Result := is_eiffel_identifier ({EL_CASE}.Lower | {EL_CASE}.Upper)
		end

	is_eiffel_lower: BOOLEAN
		-- `True' if `target' is a lower-case Eiffel identifier
		do
			Result := is_eiffel_identifier ({EL_CASE}.Lower)
		end

	is_eiffel_title: BOOLEAN
		-- `True' if `target' is an title-case Eiffel identifier
		do
			Result := is_eiffel_identifier ({EL_CASE}.Proper | {EL_CASE}.Lower)
		end

	is_eiffel_upper: BOOLEAN
		-- `True' if `target' is an upper-case Eiffel identifier
		do
			Result := is_eiffel_identifier ({EL_CASE}.Upper)
		end

	is_identifier_boundary (start_index, end_index: INTEGER): BOOLEAN
		-- `True' if indices `lower' to `upper' are an identifier boundary
		require
			valid_start_end_index: valid_substring_indices (start_index, end_index)
		local
			left_index, right_index, i: INTEGER
		do
			Result := True
			left_index := start_index - 1; right_index := end_index + 1
			if attached area as l_area then
				if left_index >= 1 then
					i := lower_abs (left_index)
					Result := not is_i_th_identifier (l_area, i)
				end
				if Result and then right_index <= count then
					i := upper_abs (right_index)
					Result := not is_i_th_identifier (l_area, i)
				end
			end
		end

	is_left_bracket_at (index: INTEGER): BOOLEAN
		require
			valid_index: valid_index (index)
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			Result := c.is_left_bracket (target [index])
		end

feature -- Substring query

	caseless_ends_with (smaller: like READABLE_X): BOOLEAN
		-- `True' if `ends_with (smaller)' is true regardless of case of `smaller'
		do
			if smaller.is_empty then
				Result := True

			elseif count >= smaller.count then
				Result := occurs_caseless_at (smaller, count - smaller.count + 1)
			end
		end

	ends_with (leading: like READABLE_X): BOOLEAN
		deferred
		end

	has_substring (other: READABLE_STRING_GENERAL): BOOLEAN
		deferred
		end

	same_caseless (other: like READABLE_X): BOOLEAN
		-- `True' if `Current' and `other' are the same regardless of case
		do
			if count = other.count then
				Result := occurs_caseless_at (other, 1)
			end
		end

	same_string (other: like READABLE_X): BOOLEAN
		-- work around for bug in `{SPECIAL}.same_items' affecting `{IMMUTABLE_STRING_8}.same_string'
		local
			l_count: INTEGER
		do
			l_count := count
			if l_count > 0 and then l_count = other.count then
				Result := same_area_items (area, other_area (other), index_lower, other_index_lower (other), l_count)
			end
		end

	starts_with (leading: like READABLE_X): BOOLEAN
		deferred
		end

feature -- Status query

	is_variable_reference: BOOLEAN
		-- `True' if `Current' is one of two variable reference forms

		-- 1. $<C identifier>
		-- 2. ${<C identifier>}
		local
			i_lower, i_upper, l_count: INTEGER
		do
			if attached target as str then
				l_count := str.count
				if l_count >= 2 and then str [1] = '$' then
					i_lower := index_lower + 1; i_upper := index_upper
				-- check if like: ${name}
					if str [2] = '{' and then l_count > 3 and then str [l_count] = '}' then
						i_lower := i_lower + 1; i_upper := i_upper - 1
					end
					Result := is_c_identifier_in_range (area, i_lower, i_upper)
				end
			end
		end

	matches_wildcard (wildcard: like READABLE_X): BOOLEAN
		-- try to match `wildcard' search term against string `s' with an asterisk either to the left,
		-- to the right or on both sides
		local
			any_ending, any_start: BOOLEAN; start_index, end_index: INTEGER
			search_string: like READABLE_X
		do
			start_index := 1; end_index := wildcard.count
			inspect wildcard.count
				when 0 then
				when 1 then
					if wildcard [1].code = {ASCII}.Star then
						any_ending := True; any_start := True
					end
			else
				if wildcard [wildcard.count].code = {ASCII}.Star then
					end_index := end_index - 1
					any_ending := True
				end
				if wildcard [1].code = {ASCII}.Star then
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
					Result := has_substring (search_string)
				end

			elseif any_ending then
				Result := starts_with (search_string)

			elseif any_start then
				Result := ends_with (search_string)
			else
				Result := same_string (wildcard)
			end
		end

feature -- Conversion

	to_utf_8: STRING
		do
			create Result.make (utf_8_byte_count)
			append_to_utf_8 (Result)
		end

feature -- Basic operations

	append_substring_to_string_32 (str: STRING_32; start_index, end_index: INTEGER)
		require
			valid_start_end_index: valid_substring_indices (start_index, end_index)
		local
			i_upper, i_lower, l_count, offset: INTEGER
		do
			l_count := end_index - start_index + 1
			if l_count > 0 then
				offset := str.count
				str.grow (offset + l_count)
				str.set_count (offset + l_count)

				i_lower := index_lower + start_index - 1
				i_upper := i_lower + l_count - 1
				append_substring_to_special_32 (area, i_lower, i_upper, str.area, offset)
			end
		ensure
			correct_size: str.count - old str.count = end_index - start_index + 1
			substring_appended: ends_with_target_substring (str, start_index, old str.count + 1)
		end

	append_substring_to_string_8 (str: STRING_8; start_index, end_index: INTEGER)
		require
			valid_start_end_index: valid_substring_indices (start_index, end_index)
		local
			i_upper, i_lower, l_count, offset: INTEGER
		do
			l_count := end_index - start_index + 1
			if l_count > 0 then
				offset := str.count
				str.grow (offset + l_count)
				str.set_count (offset + l_count)

				i_lower := index_lower + start_index - 1
				i_upper := i_lower + l_count - 1
				append_substring_to_special_8 (area, i_lower, i_upper, str.area, offset)
			end
		ensure
			correct_size: str.count - old str.count = end_index - start_index + 1
			substring_appended: ends_with_target_substring (str, start_index, old str.count + 1)
		end

	append_to_string_32 (str: STRING_32)
		do
			append_substring_to_string_32 (str, 1, target.count)
		end

	append_to_string_8 (str: STRING_8)
		require
			valid_as_string_8: is_valid_as_string_8
		do
			append_substring_to_string_8 (str, 1, target.count)
		end

	append_to_utf_8 (utf_8_out: STRING_8)
		local
			i, j, upper: INTEGER; code_i: NATURAL
		do
			if is_ascii then
				append_to_string_8 (utf_8_out)

			elseif attached area as l_area and then attached Utf_8_sequence as utf_8 then
				utf_8_out.grow (utf_8_out.count + utf_8_byte_count)
				upper := index_upper
				if attached utf_8_out.area as area_out then
					j := utf_8_out.count
					from i := index_lower until i > upper loop
						code_i := to_character_32 (l_area [i]).natural_32_code
						if code_i <= 0x7F then
							area_out [j] := code_i.to_character_8
							j := j + 1
						else
							utf_8.set_area (code_i)
							utf_8.write_to (area_out, j)
							j := j + utf_8.count
						end
						i := i + 1
					end
					area_out [j] := '%U'
					utf_8_out.set_count (j)
				end
			end
		end

	fill_z_codes (destination: STRING_32)
		-- fill destination with z_codes
		local
			i, i_upper, j: INTEGER
		do
			destination.grow (count)
			destination.set_count (count)

			if attached destination.area as destination_area and then attached area as l_area
				and then attached codec as l_codec
			then
				i_upper := index_upper
				from i := index_lower until i > i_upper loop
					destination_area [j] := l_codec.as_z_code_character (to_character_32 (l_area [i]))
					i := i + 1; j := j +1
				end
				destination_area [j] := '%U'
			end
		end

	parse (type: INTEGER; convertor: STRING_TO_NUMERIC_CONVERTOR)
		do
			parse_substring (type, 1, target.count, convertor)
		end

	parse_substring (type, start_index, end_index: INTEGER; convertor: STRING_TO_NUMERIC_CONVERTOR)
		do
			convertor.reset (type)
			parse_substring_in_range (area, type, lower_abs (start_index), upper_abs (end_index), convertor)
		end

	write_utf_8_to (utf_8_out: EL_WRITABLE)
		local
			i, i_upper: INTEGER; code_i: NATURAL
		do
			i_upper := index_upper
			if attached area as l_area and then attached Utf_8_sequence as utf_8 then
				from i := index_lower until i > i_upper loop
					code_i := to_character_32 (l_area [i]).natural_32_code
					if code_i <= 0x7F then
						utf_8_out.write_encoded_character_8 (code_i.to_character_8)
					else
						utf_8.set_area (code_i)
						utf_8.write (utf_8_out)
					end
					i := i + 1
				end
			end
		end

feature {STRING_HANDLER} -- Basic operations

	append_to (special_out: SPECIAL [CHARACTER_32]; source_index, n: INTEGER)
		-- append `n' unicode characters starting at `source_index' to `special_out' array
		require
			big_enough: (special_out.capacity - special_out.count) >= n
		local
			i, i_upper: INTEGER
		do
			if attached area as l_area then
				i_upper := (source_index + index_lower + n - 1).min (index_upper)
				from i := source_index + index_lower until i > i_upper loop
					special_out.extend (to_character_32 (l_area [i]))
					i := i + 1
				end
			end
		end

	append_to_special_32 (special_out: SPECIAL [CHARACTER_32])
		require
			big_enough: (special_out.capacity - special_out.count) >= count
		do
			append_to (special_out, 0, count)
		end

feature {NONE} -- Implementation

	all_alpha_numeric_in_range (a_area: like area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if all characters in `a_area' from `i_lower' to `i_upper' are alpha-numeric
		local
			i: INTEGER
		do
			from Result := True; i := i_lower until not Result or i > i_upper loop
				if is_i_th_alpha_numeric (a_area, i) then
					i := i + 1
				else
					Result := False
				end
			end
		end

	append_substring_to_special_32 (
		a_area: like area; i_lower, i_upper: INTEGER; area_32: SPECIAL [CHARACTER_32]; a_offset: INTEGER
	)
		local
			i, offset: INTEGER
		do
			offset := a_offset
			from i := i_lower until i > i_upper loop
				area_32 [offset] := to_character_32 (a_area [i])
				offset := offset + 1
				i := i + 1
			end
		end

	append_substring_to_special_8 (
		a_area: like area; i_lower, i_upper: INTEGER; area_8: SPECIAL [CHARACTER_8]; a_offset: INTEGER
	)
		local
			i, offset: INTEGER
		do
			offset := a_offset
			from i := i_lower until i > i_upper loop
				area_8 [offset] := to_character_8 (a_area [i])
				offset := offset + 1
				i := i + 1
			end
		end

	bracketed_substring (left_bracket: CHAR; right_to_left: BOOLEAN): like target
		-- substring of `target' enclosed by one of matching paired characters: {}, [], (), <>
		-- Empty string if `not str.has (left_bracket)' or no matching right bracket
		require
			valid_left_bracket: is_left_bracket (left_bracket)
		local
			left_index, right_index, start_index, end_index: INTEGER
		do
			start_index := 1; end_index := 0
			if right_to_left then
				left_index := last_index_of (left_bracket, count)
			else
				left_index := index_of (left_bracket, 1)
			end
			if left_index > 0 then
				right_index := matching_bracket_index (left_index)
				if right_index > 0 then
					start_index := left_index + 1; end_index := right_index - 1
				end
			end
			if target.is_immutable and then attached {IMMUTABLE_STRING_GENERAL} target as immutable then
				Result := shared_substring (immutable, start_index, end_index)
			else
				Result := target.substring (start_index, end_index)
			end
		end

	lower_abs (start_index: INTEGER): INTEGER
		-- translate `start_index' to absolute `area' index
		do
			Result := index_lower + start_index - 1
		end

	is_eiffel_identifier (case: NATURAL_8): BOOLEAN
		require
			valid_case: is_valid_case (case)
		do
			if count > 0 then
				Result := is_eiffel_identifier_in_range (area, index_lower, index_upper, case)
			end
		end

	index_of_character_type_change (
		a_area: like area; i_lower, i_upper: INTEGER; find_word: BOOLEAN; unicode: like Unicode_property
	): INTEGER
		-- index of next character that changes status from `c.is_space' to `not c.is_space'
		-- when `find_word' is true look for change to `not c.is_space'
		local
			i: INTEGER; break: BOOLEAN
		do
			from i := i_lower until i > i_upper or break loop
				if find_word then
					if not is_i_th_space (a_area, i, unicode) then
						break := True
					else
						i := i + 1
					end
				else
					if is_i_th_space (a_area, i, unicode) then
						break := True
					else
						i := i + 1
					end
				end
			end
			Result := i
		end

	null: TYPED_POINTER [INTEGER]
		do
		end

	occurrences_in_area_bounds (a_area: like area; c: CHAR; i_lower, i_upper: INTEGER): INTEGER
		-- count of `c' occurrences in area between `i_lower' and `i_upper'
		local
			i: INTEGER
		do
			from i := i_lower until i > i_upper loop
				Result := Result + (a_area [i] = c).to_integer
				i := i + 1
			end
		end

	parse_substring_in_range (a_area: like area; type, i_lower, i_upper: INTEGER; convertor: STRING_TO_NUMERIC_CONVERTOR)
		local
			i: INTEGER; failed: BOOLEAN; c_i: CHARACTER_8
		do
			from i := i_lower until i > i_upper or failed loop
				c_i := to_character_8 (a_area [i])
				inspect c_i
					when '0' .. '9', 'e', 'E', '.', '+', '-' then
						convertor.parse_character (c_i)
						if convertor.parse_successful then
							i := i + 1
						else
							failed := True
						end
				else
					convertor.reset (type); failed := True
				end
			end
		end

	right_bracket_index (a_area: like area; left_bracket: CHAR; start_index, end_index: INTEGER): INTEGER
		-- index of right bracket corresponding to `left_bracket'. `-1' if not found.
		deferred
		end

	same_area_items (a, b: like area; a_offset, b_offset, n: INTEGER): BOOLEAN
		-- Are the `n' characters of `b' from `b_offset' position the same as
		-- the `n' characters of `a' from `a_offset'?
		-- work around for bug in `{SPECIAL}.same_items' affecting `{IMMUTABLE_STRING_8}.same_string'
		require
			other_not_void: b /= Void
			source_index_non_negative: b_offset >= 0
			destination_index_non_negative: a_offset >= 0
			n_non_negative: n >= 0
			n_is_small_enough_for_source: b_offset + n <= b.count
			n_is_small_enough_for_destination: a_offset + n <= a.count
		local
			i, j, nb: INTEGER
		do
			if a = b and a_offset = b_offset then
				Result := True
			else
				Result := True
				from
					i := b_offset; j := a_offset
					nb := b_offset + n
				until
					i = nb
				loop
					if b [i] /= a [j] then
						Result := False
						i := nb - 1
					end
					i := i + 1
					j := j + 1
				end
			end
		ensure
			valid_on_empty_area: (n = 0) implies Result
		end

	substring_has_alpha (a_area: like area; start_index, end_index: INTEGER): BOOLEAN
		local
			i: INTEGER
		do
			from i := start_index until Result or else i > end_index loop
				Result := is_i_th_alpha (a_area, i)
				i := i + 1
			end
		end

	upper_abs (end_index: INTEGER): INTEGER
		-- translate `end_index' to absolute `area' index
		do
			Result := index_upper - (count - end_index)
		end

end