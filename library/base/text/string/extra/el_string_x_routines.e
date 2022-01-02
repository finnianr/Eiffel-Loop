note
	description: "String x routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-31 20:11:55 GMT (Friday 31st December 2021)"
	revision: "36"

deferred class
	EL_STRING_X_ROUTINES [S -> STRING_GENERAL create make end]

inherit
	STRING_HANDLER

	EL_MODULE_CONVERT_STRING

feature -- Status query

	has_double_quotes (s: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := has_quotes (s, 2)
		end

	has_enclosing (s, ends: READABLE_STRING_GENERAL): BOOLEAN
			--
		require
			ends_has_2_characters: ends.count = 2
		do
			Result := s.count >= 2
				and then s.item (1) = ends.item (1) and then s.item (s.count) = ends.item (2)
		end

	has_quotes (s: READABLE_STRING_GENERAL; type: INTEGER): BOOLEAN
		require
			double_or_single: 1 <= type and type <= 2
		local
			quote_code: NATURAL
		do
			if type = 1 then
				quote_code := ('%'').natural_32_code
			else
				quote_code := ('"').natural_32_code
			end
			Result := s.count >= 2 and then s.code (1) = quote_code and then s.code (s.count) = quote_code
		end

	has_single_quotes (s: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := has_quotes (s, 1)
		end

	is_ascii (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if all characters in `str' are in the ASCII character set: 0 .. 127
		deferred
		end

	is_convertible (s: READABLE_STRING_GENERAL; basic_type: TYPE [ANY]): BOOLEAN
		-- `True' if `str' is convertible to type `basic_type'
		do
			Result := Convert_string.is_convertible (s, basic_type)
		end

	is_eiffel_identifier (s: READABLE_STRING_GENERAL): BOOLEAN
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until i > s.count or not Result loop
				inspect s [i]
					when 'a' .. 'z', 'A' .. 'Z', '0' .. '9', '_' then
						Result := i = 1 implies s.item (1).is_alpha
				else
					Result := False
				end
				i := i + 1
			end
		end

	is_punctuation (c: CHARACTER_32): BOOLEAN
		do
			Result := c.is_punctuation
		end

	is_word (str: S): BOOLEAN
		do
			Result := not str.is_empty
		end

feature -- Basic operations

	append_to (str: S; extra: READABLE_STRING_GENERAL)
		deferred
		end

	search_interval_at_nth (text, search_string: S; n: INTEGER): INTEGER_INTERVAL
			--
		local
			l_occurrences: EL_OCCURRENCE_INTERVALS [S]
		do
			create l_occurrences.make_by_string (text, search_string)
			from l_occurrences.start until l_occurrences.after or l_occurrences.index > n loop
				l_occurrences.forth
			end
			Result := l_occurrences.item_interval
		end

	set_upper (str: S; i: INTEGER)
		require
			valid_index: 0 < i and i <= str.count
		deferred
		end

	write_utf_8 (s: READABLE_STRING_GENERAL; writeable: EL_WRITEABLE)
		local
			i: INTEGER; c: EL_CHARACTER_8_ROUTINES
		do
			from i := 1 until i > s.count loop
				c.write_utf_8 (s [i], writeable)
				i := i + 1
			end
		end

feature -- Measurement

	latin_1_count (s: READABLE_STRING_GENERAL): INTEGER
		-- count of latin-1 characters
		deferred
		end

	leading_occurences (s: READABLE_STRING_GENERAL; c: CHARACTER_32): INTEGER
		deferred
		end

	leading_white_count (s: READABLE_STRING_GENERAL): INTEGER
		deferred
		end

	maximum_count (strings: ITERABLE [READABLE_STRING_GENERAL]): INTEGER
			--
		do
			across strings as str loop
				if str.item.count > Result then
					Result := str.item.count
				end
			end
		end

	occurrences (text, search_string: S): INTEGER
			--
		local
			l_occurrences: EL_OCCURRENCE_INTERVALS [S]
		do
			create l_occurrences.make_by_string (text, search_string)
			from l_occurrences.start until l_occurrences.after loop
				Result := Result + 1
				l_occurrences.forth
			end
		end

	trailing_white_count (s: READABLE_STRING_GENERAL): INTEGER
		deferred
		end

	word_count (str: READABLE_STRING_GENERAL): INTEGER
		do
			across str.split ('%N') as line loop
				across words (line.item) as word loop
					if is_word (word.item) then
						Result := Result + 1
					end
				end
			end
		end

feature -- Conversion

	to_type (str: READABLE_STRING_GENERAL; basic_type: TYPE [ANY]): detachable ANY
		-- `str' converted to type `basic_type'
		do
			Result := Convert_string.to_type (str, basic_type)
		end

feature -- Lists

	delimited_list (text, delimiter: S): LIST [S]
			-- string delimited list
		local
			splits: EL_SPLIT_STRING_LIST [S]
		do
			create splits.make_by_string (text, delimiter)
			Result := splits.as_string_list
		end

	to_list (text: S): LIST [S]
		-- comma separated list
		local
			comma: S
		do
			create comma.make (1)
			comma.append_code ((',').natural_32_code)
			Result := delimited_list (text, comma)
			Result.do_all (agent left_adjust)
		end

	words (str: READABLE_STRING_GENERAL): LIST [S]
			-- unpunctuated words
		local
			i: INTEGER; l_str: S
		do
			create l_str.make (str.count)
			from i := 1 until i > str.count loop
				if not is_punctuation (str [i]) then
					l_str.append_code (str.code (i))
				end
				i := i + 1
			end
			Result := l_str.split (' ')
		end

feature -- Transformed

	adjusted (str: S): S
		local
			start_index, end_index: INTEGER
		do
			end_index := str.count - trailing_white_count (str)
			if end_index.to_boolean then
				start_index := leading_white_count (str) + 1
			else
				start_index := 1
			end
			if start_index = 1 and then end_index = str.count then
				Result := str
			else
				Result := str.substring (start_index, end_index)
			end
		end

	enclosed (str: READABLE_STRING_GENERAL; left, right: CHARACTER_32): S
			--
		do
			create Result.make (str.count + 2)
			Result.append_code (left.natural_32_code)
			append_to (Result, str)
			Result.append_code (right.natural_32_code)
		end

	joined_lines (list: ITERABLE [READABLE_STRING_GENERAL]): S
		do
			Result := joined_with (list, once "%N")
		end

	joined_with (list: ITERABLE [READABLE_STRING_GENERAL]; delimiter: READABLE_STRING_GENERAL): S
		local
			char_count, count: INTEGER
		do
			across list as ln loop
				char_count := char_count + ln.item.count
				count := count + 1
			end
			if count > 0 then
				create Result.make (char_count + (count - 1) * delimiter.count)
				across list as ln loop
					if Result.count > 0 then
						append_to (Result, delimiter)
					end
					append_to (Result, ln.item)
				end
			else
				create Result.make (0)
			end
		end

	leading_delimited (text, delimiter: S; include_delimiter: BOOLEAN): S
			--
		local
			l_occurrences: EL_OCCURRENCE_INTERVALS [S]
		do
			create l_occurrences.make_by_string (text, delimiter)
			l_occurrences.start
			if l_occurrences.after then
				create Result.make (0)
			else
				if include_delimiter then
					Result := text.substring (1, l_occurrences.item_upper)
				else
					Result := text.substring (1, l_occurrences.item_lower - 1)
				end
			end
		end

	pruned (str: READABLE_STRING_GENERAL; c: CHARACTER_32): S
		deferred
		end

	quoted (str: READABLE_STRING_GENERAL; quote_type: INTEGER): S
		require
			single_or_double: (1 |..| 2).has (quote_type)
		local
			c: CHARACTER
		do
			if quote_type = 1 then
				c := '%''
			else
				c := '"'
			end
			Result := enclosed (str, c, c)
		end

	spaces (width, count: INTEGER): S
			-- width * count spaces
		local
			i, n: INTEGER
		do
			n := width * count
			create Result.make (n)
			from i := 1 until i > n loop
				Result.append_code (32)
				i := i + 1
			end
		end

	substring_to (str: S; uc: CHARACTER_32; start_index_ptr: POINTER): S
		-- substring from INTEGER at memory location `start_index_ptr' up to but not including index of `uc'
		-- or else `substring_end (start_index)' if `uc' not found
		-- `start_index' is 1 if `start_index_ptr = Default_pointer'
		-- write new start_index back to `start_index_ptr'
		-- if `uc' not found then new `start_index' is `count + 1'
		local
			start_index, index: INTEGER
		do
			if start_index_ptr = Default_pointer then
				start_index := 1
			else
				start_index := pointer.read_integer (start_index_ptr)
			end
			index := str.index_of (uc, start_index)
			if index > 0 then
				Result := str.substring (start_index, index - 1)
				start_index := index + 1
			else
				Result := str.substring (start_index, str.count)
				start_index := str.count + 1
			end
			if start_index_ptr /= Default_pointer then
				start_index_ptr.memory_copy ($start_index, {PLATFORM}.Integer_32_bytes)
			end
		end

	substring_to_reversed (str: S; uc: CHARACTER_32; start_index_from_end_ptr: POINTER): S
		-- the same as `substring_to' except going from right to left
		-- if `uc' not found `start_index_from_end' is set to `0' and written back to `start_index_from_end_ptr'
		local
			start_index_from_end, index: INTEGER
		do
			if start_index_from_end_ptr = Default_pointer then
				start_index_from_end := str.count
			else
				start_index_from_end := pointer.read_integer (start_index_from_end_ptr)
			end
			index := last_index_of (str, uc, start_index_from_end)
			if index > 0 then
				Result := str.substring (index + 1, start_index_from_end)
				start_index_from_end := index - 1
			else
				Result := str.substring (1, start_index_from_end)
				start_index_from_end := 0
			end
			if start_index_from_end_ptr /= Default_pointer then
				pointer.put_integer (start_index_from_end, start_index_from_end_ptr)
			end
		end

	truncated (str: S; max_count: INTEGER): S
		-- return `str' truncated to `max_count' characters, adding ellipsis where necessary
		do
			if str.count <= max_count then
				Result := str
			else
				Result := str.substring (1, max_count - 2)
				str.append_code ({ASCII}.Dot.to_natural_32)
				str.append_code ({ASCII}.Dot.to_natural_32)
			end
		end

	unbracketed (str: READABLE_STRING_GENERAL; left_bracket: CHARACTER_32): S
			-- Returns text enclosed in one of matching paired characters: {}, [], (), <>
		require
			valid_left_bracket: ({STRING_32} "{[(<").has (left_bracket)
		local
			right_chararacter: CHARACTER_32
			offset: NATURAL; left_index, right_index, i: INTEGER
			l_result: READABLE_STRING_GENERAL
		do
			create Result.make (0)

			if left_bracket = '(' then
				offset := 1
			else
				offset := 2
			end
			right_chararacter := (left_bracket.natural_32_code + offset).to_character_32
			left_index := str.index_of (left_bracket, 1)
			right_index := str.index_of (right_chararacter, left_index + 1)
			if left_index > 0 and then right_index > 0 and then right_index - left_index > 1 then
				l_result := str.substring (left_index + 1, right_index - 1)
				from i := 1 until i > l_result.count loop
					Result.append_code (l_result.code (i))
					i := i + 1
				end
			end
		end

feature -- Transform

	first_to_upper (str: STRING_GENERAL)
		do
			if not str.is_empty then
				str.put_code (str.item (1).as_upper.natural_32_code, 1)
			end
		end

	left_adjust (str: S)
		deferred
		end

	prune_all_leading (str: S; c: CHARACTER_32)
		deferred
		end

	remove_bookends (str: S; ends: READABLE_STRING_GENERAL)
			--
		require
			ends_has_2_characters: ends.count = 2
		do
			if str.item (1) = ends.item (1) then
				str.keep_tail (str.count - 1)
			end
			if str.item (str.count) = ends.item (2) then
				str.set_count (str.count - 1)
			end
		end

	remove_double_quote (quoted_str: S)
			--
		do
			remove_bookends (quoted_str, once "%"%"" )
		end

	remove_single_quote (quoted_str: S)
			--
		do
			remove_bookends (quoted_str, once "''" )
		end

	replace_character (target: S; uc_old, uc_new: CHARACTER_32)
		local
			i: INTEGER; code_old, code_new: NATURAL
		do
			code_old := uc_old.natural_32_code; code_new := uc_new.natural_32_code
			from i := 1 until i > target.count loop
				if target.code (i) = code_old then
					target.put_code (code_new, i)
				end
				i := i + 1
			end
		end

	right_adjust (str: S)
		deferred
		end

	translate (target, old_characters, new_characters: S)
		do
			translate_deleting_null_characters (target, old_characters, new_characters, False)
		end

	translate_and_delete (target, old_characters, new_characters: S)
		do
			translate_deleting_null_characters (target, old_characters, new_characters, True)
		end

	translate_deleting_null_characters (target, old_characters, new_characters: S; delete_null: BOOLEAN)
		require
			each_old_has_new: old_characters.count = new_characters.count
		local
			source: S; c, new_c: CHARACTER_32; i, index: INTEGER
		do
			source := target.twin
			target.set_count (0)
			from i := 1 until i > source.count loop
				c := source [i]
				index := old_characters.index_of (c, 1)
				if index > 0 then
					new_c := new_characters [index]
					if delete_null implies new_c > '%U' then
						target.append_code (new_c.natural_32_code)
					end
				else
					target.append_code (c.natural_32_code)
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	last_index_of (str: S; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		deferred
		end

	pointer: EL_POINTER_ROUTINES
		-- expanded instance
		do
		end

end