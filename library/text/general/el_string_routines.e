note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_STRING_ROUTINES

inherit
	KL_STRING_ROUTINES
		rename
			dummy_string as Empty_string
		export
			{ANY} Empty_string
		redefine
			hexadecimal_to_integer, is_hexadecimal
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	EL_MODULE_CHARACTER
		export
			{NONE} all
		end

	UC_IMPORTED_UTF8_ROUTINES
		export
			{NONE} all
		end

	STRING_HANDLER
		export
			{NONE} all
		end

	EL_MODULE_UTF

feature -- Transformation

	template (str: READABLE_STRING_GENERAL): EL_TEMPLATE_STRING
		do
			create Result.make_from_unicode (str)
		end

	abbreviate_working_directory (str: STRING): STRING
			--
		do
			create Result.make_from_string (str)
			Result.replace_substring_all (Execution.current_working_directory.to_string, "$CWD")
		end

	indented_text (text: EL_ASTRING; tabs: INTEGER): EL_ASTRING
			-- replace new lines in text with indented new lines
		local
			tabbed_new_line: EL_ASTRING
			lines: LIST [EL_ASTRING]
		do
			create tabbed_new_line.make_filled ('%T', tabs)
			tabbed_new_line.prepend_character ('%N')
			create Result.make (text.count + text.occurrences ('%N') * tabs)
			lines := text.split ('%N')
			from lines.start until lines.after loop
				if not lines.isfirst then
					Result.append (tabbed_new_line)
				end
				Result.append (lines.item)
				lines.forth
			end
		end

	joined_words (strings: INDEXABLE [READABLE_STRING_GENERAL, INTEGER]): EL_ASTRING
			--
		do
			Result := joined (strings, once " ")
		end

	joined (strings: INDEXABLE [READABLE_STRING_GENERAL, INTEGER]; separator: EL_ASTRING): EL_ASTRING
			--
		local
			i: INTEGER
			bounds: INTEGER_INTERVAL
			item: READABLE_STRING_GENERAL
		do
			bounds := strings.index_set
			Result := Internal_string
			Result.wipe_out
			from i := bounds.lower until i > bounds.upper loop
				if i > 1 then
					Result.append (separator)
				end
				item := strings [i]
				if attached {EL_ASTRING} item as el_item then
					Result.append (el_item)
				else
					Result.append (create {EL_ASTRING}.make_from_unicode (item))
				end
				i := i + 1
			end
			Result := Result.twin
		end

	leading_delimited (text, delimiter: STRING; include_delimiter: BOOLEAN): STRING
			--
		local
			l_occurrences: EL_OCCURRENCE_SUBSTRINGS
		do
			create l_occurrences.make (text, delimiter)
			l_occurrences.start
			if l_occurrences.after then
				Result := ""
			else
				if include_delimiter then
					Result := text.substring (1, l_occurrences.interval.upper)
				else
					Result := text.substring (1, l_occurrences.interval.lower - 1)
				end
			end
		end

	normalized_word_case (text: EL_ASTRING; minimum_word_count: INTEGER): EL_ASTRING
			--
		local
			words: EL_ASTRING_LIST
			word: STRING
		do
			create words.make_with_words (text)
			create Result.make_empty
			from words.start until words.after loop
				if words.index > 1 then
					Result.append_character (Blank_character)
				end
				word := words.item.as_lower
				if word.count >= minimum_word_count or words.index = 1 then
					word.put (word.item (1).as_upper, 1)
				end
				Result.append (word)
				words.forth
			end
		end

	quoted (str: EL_ASTRING): EL_ASTRING
			--
		do
			Result := bookended (str, '%"', '%"')
		end

	bookended (str: EL_ASTRING; left_bookend, right_bookend: CHARACTER): EL_ASTRING
			--
		do
			create Result.make (str.count + 2)
			Result.append_character (left_bookend)
			Result.append (str)
			Result.append_character (right_bookend)
		end

	enclosed (str: STRING; left_chararacter: CHARACTER): STRING
			-- Returns text enclosed in one of matching paired characters: {}, [], (), <>
		require
			valid_left_chararacter: ("{[(<").has (left_chararacter)
		local
			right_chararacter: CHARACTER
			offset, left_index, right_index: INTEGER
		do
			if left_chararacter = '(' then
				offset := 1
			else
				offset := 2
			end
			right_chararacter := (left_chararacter.code + offset).to_character_8
			left_index := str.index_of (left_chararacter, 1)
			right_index := str.index_of (right_chararacter, left_index + 1)
			if left_index > 0 and then right_index > 0 and then right_index - left_index > 1 then
				Result := str.substring (left_index + 1, right_index - 1)
			else
				create Result.make_empty
			end
		end

	space_chars (width, count: INTEGER): STRING
			-- width * count spaces
		do
			create Result.make_filled (Blank_character, width * count)
		end

	unescaped_C_string, unescaped_Python_double_quoted (str: EL_ASTRING): EL_ASTRING
			--
		do
			Result := unescaped (str, '\', C_language_special_characters)
		end

	unescaped_Python_single_quoted (str: EL_ASTRING): EL_ASTRING
			--
		do
			Result := unescaped (str, '\', Python_single_quoted_special_characters)
		end

	unescaped (
		str: EL_ASTRING; escape_character: CHARACTER; escape_set: HASH_TABLE [CHARACTER, CHARACTER]
	): EL_ASTRING
			--
		local
			i: INTEGER
		do
			Result := str.twin
			Result.wipe_out
			from i := 1 until i > str.count loop
				if str.item (i) = escape_character and then i < str.count
					and then escape_set.has (str.item (i + 1))
				then
					Result.append_character (escape_set.item (str.item (i + 1)))
					i := i + 2
				else
					Result.append_character (str.item (i))
					i := i + 1
				end
			end
			Result.set_foreign_characters (str.foreign_characters)
		end

feature -- Measurement

	maximum_count (strings: INDEXABLE [READABLE_STRING_GENERAL, INTEGER]): INTEGER
			--
		local
			i, count: INTEGER
		do
			count := strings.index_set.upper
			from i := 1 until i > count loop
				if strings.item (i).count > Result then
					Result := strings.item (i).count
				end
				i := i + 1
			end
		end

	occurrences (text, search_string: STRING): INTEGER
			--
		local
			l_occurrences: EL_OCCURRENCE_SUBSTRINGS
		do
			create l_occurrences.make (text, search_string)
			from l_occurrences.start until l_occurrences.after loop
				Result := Result + 1
				l_occurrences.forth
			end
		end

feature -- Hexadecimal conversion

	hexadecimal_to_integer (str: STRING): INTEGER
			--
		local
			lcase_str: STRING
		do
			lcase_str := str.as_lower
			Result := Precursor (
				lcase_str.substring (lcase_str.index_of ('x', 1) + 1, lcase_str.count)
			)
		end

	hexadecimal_to_natural_64 (str: STRING): NATURAL_64
			--
		local
			s: STRING
			i: INTEGER
			place_value: NATURAL_64
		do
			s := str.string
			if s.count > 2 and then s.item (2) = 'x' then
				s.put ('0', 2)
			end
			s.prune_all_leading ('0')
			from i := 1 until i > s.count loop
				place_value := Character.hex_digit_to_decimal (s @ i).to_natural_64
				Result := Result | place_value.bit_shift_left ((s.count - i) * 4)
				i := i + 1
			end
		end

	integer_to_hexadecimal (v: INTEGER): STRING
		do
			create Result.make (10)
			Result.append (once "0x")
			Result.append (v.to_hex_string)
		end

	array_to_hex_string (array: SPECIAL [NATURAL_8]): STRING
		local
			i: INTEGER; n: NATURAL_8
		do
			create Result.make (array.count * 2)
			from i := 0 until i = array.count loop
				n := array.item (i)
				Result.append_character ((n |>> 4).to_hex_character)
				Result.append_character ((n & 0xF).to_hex_character)
				i := i + 1
			end
		end

feature -- Conversion

	csv_string_to_reals (comma_separated_values: STRING; default_value: REAL): ARRAY [REAL]
			--
		local
			csv_list: LIST [STRING]
			i: INTEGER
		do
			csv_list := comma_separated_values.split (',')
			create Result.make (1, csv_list.count)
			from
				csv_list.start
				i := 1
			until
				csv_list.after
			loop
				if csv_list.item.is_real then
					Result [i] := csv_list.item.to_real
				else
					-- undefined
					Result [i] := default_value
				end
				i := i + 1
				csv_list.forth
			end
		end

	comma_separated_list (comma_separated_values: STRING): LIST [STRING]
			--
		do
			Result := separated_list (comma_separated_values, ',')
		end

	separated_list (str: STRING; delimiter: CHARACTER): LIST [STRING]
			-- character delimited list of right and left adjusted strings
		do
			Result := str.split (delimiter)
			Result.do_all (agent (value: STRING) do value.right_adjust; value.left_adjust end)
		end

	delimited_list (text, delimiter: EL_ASTRING): LIST [EL_ASTRING]
			-- string delimited list
		local
			delimited_substrings: EL_DELIMITED_SUBSTRINGS
		do
			create delimited_substrings.make (text, delimiter)
			Result := delimited_substrings.substring_list
		end

	hex_code_sequence_to_string_32 (hex_code_sequence: STRING): STRING_32
			-- convert space separated hexadecimal codes to STRING32
		local
			i, l_code: INTEGER
			l_character: like Character
			c: CHARACTER
		do
			l_character := Character
			if hex_code_sequence.is_empty then
				create Result.make_empty
			else
				create Result.make (hex_code_sequence.occurrences (' ') + 1)
				from i := 1 until i > hex_code_sequence.count loop
					c := hex_code_sequence [i]
					if c = ' ' then
						if i > 1 then
							Result.append_code (l_code.to_natural_32)
						end
						l_code := 0
					else
						l_code := (l_code |<< 4) | l_character.hex_digit_to_decimal (c)
					end
					i := i + 1
				end
				Result.append_code (l_code.to_natural_32)
			end
		ensure
			correct_count: Result.full
		end

	sorted (a_list: INDEXABLE [STRING, INTEGER]): LIST [STRING]
			-- Sorted alphabetically
		local
			i, count: INTEGER
			l_array: SORTABLE_ARRAY [STRING]
		do
			count := a_list.index_set.upper
			create l_array.make_filled (Empty_string, 1, count)
			from i := 1 until i > count loop
				l_array [i] := a_list [i]
				i := i + 1
			end
			l_array.sort
			create {ARRAYED_LIST [STRING]} Result.make_from_array (l_array)
		end

	string_from_general (s: READABLE_STRING_GENERAL): EL_ASTRING
			--
		do
			if attached {EL_ASTRING} s as a_s then
				Result := a_s
			else
				create Result.make_from_unicode (s)
			end
		end

feature -- Encoding conversion: STRING_32

	as_utf8 (str: READABLE_STRING_GENERAL): STRING
			-- Write `s' at current position.
		do
			if attached {EL_ASTRING} str as l_str then
				Result := l_str.to_utf8

			elseif attached {STRING_32} str as l_unicode then
				Result := UTF.string_32_to_utf_8_string_8 (l_unicode)

			elseif attached {STRING_8} str as l_latin1 then
				Result := l_latin1.twin

			else
				create Result.make_empty
			end
		end

feature -- Status query

	string_not_longer_than_maximum (str: STRING; max_length: INTEGER): BOOLEAN
			--
		do
			Result := str.count < max_length
		end

	string_shorter_than (str: STRING; maximum_length_plus_one: INTEGER): BOOLEAN
			--
		do
			Result := str.count < maximum_length_plus_one
		end

	not_a_has_substring_b (a, b: STRING): BOOLEAN
			--
		require
			a_string_long_enough: a.count > 0
		do
			Result := not a.has_substring (b)
		end

	not_a_ends_with_b (a, b: STRING): BOOLEAN
			--
		do
			Result := not a.ends_with (b)
		end

	is_hexadecimal (str: STRING): BOOLEAN
			--
		local
			lcase_str: STRING
		do
			lcase_str := str.as_lower
			Result := Precursor (lcase_str.substring (lcase_str.index_of ('x', 1) + 1, lcase_str.count))
		end

	has_enclosing (s, ends: READABLE_STRING_GENERAL): BOOLEAN
			--
		require
			ends_has_2_characters: ends.count = 2
		do
			Result := s.count >= 2
				and then s.item (1) = ends.item (1) and then s.item (s.count) = ends.item (2)
		end

	has_double_quotes (s: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := has_enclosing (s, once "%"%"")
		end

	has_single_quotes (s: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := has_enclosing (s, once "''")
		end

feature -- Character editing

	subst_all_characters (str: STRING_GENERAL; char, subst_char: CHARACTER_32)
			--
		local
			i: INTEGER
			char_code, subst_char_code: NATURAL
		do
			char_code := char.natural_32_code
			subst_char_code := subst_char.natural_32_code
			from i := 1 until i > str.count loop
				if str.code (i) = char_code then
					str.put_code (subst_char_code, i)
				end
				i := i + 1
			end
		end

	trim_string_to_length (str: STRING; length: INTEGER)
			--
		do
			if str.count > length then
				str.remove_tail (length - str.count)
			end
		end

	remove_double_quote (quoted_str: STRING)
			--
		do
			remove_bookends (quoted_str, once "%"%"" )
		end

	remove_single_quote (quoted_str: STRING)
			--
		do
			remove_bookends (quoted_str, once "''" )
		end

	remove_bookends (s: STRING_GENERAL; ends: READABLE_STRING_GENERAL)
			--
		require
			ends_has_2_characters: ends.count = 2
		do
			if s.item (1) = ends.item (1) then
				s.keep_tail (s.count - 1)
			end
			if s.item (s.count) = ends.item (2) then
				s.set_count (s.count - 1)
			end
		end

feature -- Search operations

	search_interval_at_nth (text, search_string: STRING; n: INTEGER): INTEGER_INTERVAL
			--
		local
			l_occurrences: EL_OCCURRENCE_SUBSTRINGS
		do
			create l_occurrences.make (text, search_string)
			from l_occurrences.start until l_occurrences.after or l_occurrences.index > n loop
				l_occurrences.forth
			end
			Result := l_occurrences.interval.twin
		end

feature -- Constants

	Blank_character: CHARACTER_8
			--
		once
			Result := {ASCII}.Blank.to_character_8
		end

	Default_character: CHARACTER

	C_language_special_characters: HASH_TABLE [CHARACTER, CHARACTER]
			--
		once
			create Result.make (4)
			Result ['t'] := '%T'
			Result ['n'] := '%N'
			Result ['\'] := '\'
			Result ['"'] := '"'
		end

	Python_single_quoted_special_characters: HASH_TABLE [CHARACTER, CHARACTER]
			--
		once
			create Result.make (4)
			Result ['t'] := '%T'
			Result ['n'] := '%N'
			Result ['\'] := '\'
			Result ['%''] := '%''
		end

feature {NONE} -- Implementation

	Internal_string: EL_ASTRING
			--
		once
			create Result.make_empty
		end

end -- class STRING_ROUTINES
