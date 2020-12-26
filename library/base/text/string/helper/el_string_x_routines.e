note
	description: "String x routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-23 10:49:20 GMT (Wednesday 23rd December 2020)"
	revision: "20"

deferred class
	EL_STRING_X_ROUTINES [S -> STRING_GENERAL create make_empty, make end]

inherit
	STRING_HANDLER

	EL_MODULE_CHAR_8

feature -- Basic operations

	append_to (str: S; extra: READABLE_STRING_GENERAL)
		do
			if attached {STRING} extra as str_8 then
				str.append (str_8)
			else
				str.append (extra.to_string_32) -- Might be ZSTRING
			end
		end

	search_interval_at_nth (text, search_string: S; n: INTEGER): INTEGER_INTERVAL
			--
		local
			l_occurrences: EL_OCCURRENCE_INTERVALS [S]
		do
			create l_occurrences.make (text, search_string)
			from l_occurrences.start until l_occurrences.after or l_occurrences.index > n loop
				l_occurrences.forth
			end
			Result := l_occurrences.item_interval
		end

	write_utf_8 (s: READABLE_STRING_GENERAL; writeable: EL_WRITEABLE)
		local
			i: INTEGER; routines: like Char_8
		do
			routines := Char_8
			from i := 1 until i > s.count loop
				routines.write_utf_8 (s [i], writeable)
				i := i + 1
			end
		end

feature -- Measurement

	latin_1_count (s: READABLE_STRING_GENERAL): INTEGER
		-- count of latin-1 characters
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

feature -- Conversion

	general_to_unicode (s: READABLE_STRING_GENERAL): STRING_32
		obsolete
			"Just call `to_string_32'. It works with ZSTRING's too"
		do
			Result := s.to_string_32
		end

	to_type (str: READABLE_STRING_GENERAL; basic_type: TYPE [ANY]): ANY
		-- `str' converted to type `basic_type'
		require
			convertible: is_convertible (str, basic_type)
		local
			to_basic_type: FUNCTION [READABLE_STRING_GENERAL, ANY]
		do
			if Conversion_table.has_key (basic_type) then
				to_basic_type := Conversion_table.found_item.to_type
				Result := to_basic_type (str)
			else
				create Result
			end
		end

	to_character_8 (str: READABLE_STRING_GENERAL): CHARACTER_8
		require
			is_character_8: is_character_8 (str)
		do
			if is_character_8 (str) then
				Result := str.item (1).to_character_8
			end
		end

	to_character_32 (str: READABLE_STRING_GENERAL): CHARACTER_32
		require
			is_character_32: is_character_32 (str)
		do
			if is_character_32 (str) then
				Result := str.item (1)
			end
		end

feature -- Lists

	delimited_list (text, delimiter: S): LIST [S]
			-- string delimited list
		local
			splits: EL_SPLIT_STRING_LIST [S]
		do
			create splits.make (text, delimiter)
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

feature -- Transformation

	enclosed (str: READABLE_STRING_GENERAL; left, right: CHARACTER_32): S
			--
		do
			create Result.make (str.count + 2)
			Result.append_code (left.natural_32_code)
			append_to (Result, str)
			Result.append_code (right.natural_32_code)
		end

	first_to_upper (str: STRING_GENERAL)
		do
			if not str.is_empty then
				str.put_code (str.item (1).as_upper.natural_32_code, 1)
			end
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
			create l_occurrences.make (text, delimiter)
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

	left_adjust (str: S)
		deferred
		end

	prune_all_leading (str: S; c: CHARACTER_32)
		deferred
		end

	quoted (str: READABLE_STRING_GENERAL): S
			--
		do
			Result := enclosed (str, '%"', '%"')
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
			create Result.make_empty

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

	unescape (
		str: STRING_GENERAL; escape_character: CHARACTER_32;  escaped_characters: HASH_TABLE [CHARACTER_32, CHARACTER_32]
	)
		require
			double_escapes_are_literal_escapes: escaped_characters [escape_character] = escape_character
		local
			pos_escape, start_index: INTEGER
		do
			from pos_escape := str.index_of (escape_character, 1) until pos_escape = 0 loop
				if pos_escape + 1 <= str.count then
					if escaped_characters.has_key (str [pos_escape + 1]) then
						str.put_code (escaped_characters.found_item.natural_32_code, pos_escape + 1)
						str.remove (pos_escape)
						start_index := pos_escape + 1
					else
						start_index := pos_escape + 2
					end
					pos_escape := str.index_of (escape_character, start_index)
				else
					pos_escape := 0
				end
			end
		end

feature -- Status query

	has_double_quotes (s: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := has_enclosing (s, once "%"%"")
		end

	has_enclosing (s, ends: READABLE_STRING_GENERAL): BOOLEAN
			--
		require
			ends_has_2_characters: ends.count = 2
		do
			Result := s.count >= 2
				and then s.item (1) = ends.item (1) and then s.item (s.count) = ends.item (2)
		end

	has_single_quotes (s: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := has_enclosing (s, once "''")
		end

	is_convertible (s: READABLE_STRING_GENERAL; basic_type: TYPE [ANY]): BOOLEAN
		-- `True' if `str' is convertible to type `basic_type'
		local
			convertible: PREDICATE [READABLE_STRING_GENERAL]
		do
			if Conversion_table.has_key (basic_type) then
				convertible := Conversion_table.found_item.is_convertible
				Result := convertible (s)
			end
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

	is_character_8 (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := str.count = 1 and then str.code (1) <= 0xFF
		end

	is_character_32 (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := str.count = 1
		end

feature -- Measurement

	occurrences (text, search_string: S): INTEGER
			--
		local
			l_occurrences: EL_OCCURRENCE_INTERVALS [S]
		do
			create l_occurrences.make (text, search_string)
			from l_occurrences.start until l_occurrences.after loop
				Result := Result + 1
				l_occurrences.forth
			end
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

feature {NONE} -- Constants

	Conversion_table: EL_HASH_TABLE [
		TUPLE [is_convertible: PREDICATE [READABLE_STRING_GENERAL]; to_type: FUNCTION [READABLE_STRING_GENERAL, ANY]],
		TYPE [ANY] -- basic type lookup key
	]
		-- string conversion predicates and conversion function
		once
			create Result.make (<<
				[{BOOLEAN},			[agent {READABLE_STRING_GENERAL}.is_boolean, agent {READABLE_STRING_GENERAL}.to_boolean]],

				[{CHARACTER_8},	[agent is_character_8, agent to_character_8]],
				[{CHARACTER_32},	[agent is_character_32, agent to_character_32]],

				[{INTEGER_8},		[agent {READABLE_STRING_GENERAL}.is_integer_8, agent {READABLE_STRING_GENERAL}.to_integer_8]],
				[{INTEGER_16}, 	[agent {READABLE_STRING_GENERAL}.is_integer_16, agent {READABLE_STRING_GENERAL}.to_integer_16]],
				[{INTEGER_32},		[agent {READABLE_STRING_GENERAL}.is_integer_32, agent {READABLE_STRING_GENERAL}.to_integer_32]],
				[{INTEGER_64},		[agent {READABLE_STRING_GENERAL}.is_integer_64, agent {READABLE_STRING_GENERAL}.to_integer_64]],

				[{NATURAL_8},		[agent {READABLE_STRING_GENERAL}.is_natural_8, agent {READABLE_STRING_GENERAL}.to_natural_8]],
				[{NATURAL_16},		[agent {READABLE_STRING_GENERAL}.is_natural_16, agent {READABLE_STRING_GENERAL}.to_natural_16]],
				[{NATURAL_32},		[agent {READABLE_STRING_GENERAL}.is_natural_32, agent {READABLE_STRING_GENERAL}.to_natural_32]],
				[{NATURAL_64},		[agent {READABLE_STRING_GENERAL}.is_natural_64, agent {READABLE_STRING_GENERAL}.to_natural_64]],

				[{DOUBLE},			[agent {READABLE_STRING_GENERAL}.is_double, agent {READABLE_STRING_GENERAL}.to_double]],
				[{REAL},				[agent {READABLE_STRING_GENERAL}.is_real, agent {READABLE_STRING_GENERAL}.to_real]]
			>>)
		end
end