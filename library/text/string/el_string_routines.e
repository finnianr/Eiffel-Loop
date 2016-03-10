note
	description: "String routines"

	notes: "[
		Development strategy:
		Migrate these functions into EL_STRING_X_ROUTINES and access via
		EL_MODULE_STRING_8 and EL_MODULE_STRING_32
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-24 12:11:25 GMT (Friday 24th January 2014)"
	revision: "4"

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

	EL_MODULE_DIRECTORY
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

	abbreviate_working_directory (str: STRING): STRING
			--
		do
			create Result.make_from_string (str)
			Result.replace_substring_all (Directory.Working.to_string, "$CWD")
		end

	indented_text (indent: STRING; text: ASTRING): ASTRING
			-- replace new lines in text with indented new lines
		local
			lines: LIST [ASTRING]
		do
			create Result.make (text.count + (text.occurrences ('%N') + 1) * indent.count)
			lines := text.split ('%N')
			from lines.start until lines.after loop
				Result.append_string (indent)
				Result.append (lines.item)
				if not lines.islast then
					Result.append_character ('%N')
				end
				lines.forth
			end
		end

	joined_words (strings: INDEXABLE [READABLE_STRING_GENERAL, INTEGER]): ASTRING
			--
		do
			Result := joined (strings, once " ")
		end

	joined (strings: INDEXABLE [READABLE_STRING_GENERAL, INTEGER]; separator: ASTRING): ASTRING
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
				if attached {ASTRING} item as el_item then
					Result.append (el_item)
				else
					Result.append (create {ASTRING}.make_from_unicode (item))
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

	normalized_word_case (text: ASTRING; minimum_word_count: INTEGER): ASTRING
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

	space_chars (width, count: INTEGER): STRING
			-- width * count spaces
		do
			create Result.make_filled (Blank_character, width * count)
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

	adjust_verbatim (str: STRING)
			-- Work around for compiler bug that indents verbatim string when it shouldn't
		local
			old_count, tab_count: INTEGER
			old_indent, new_line: STRING
		do
			old_count := str.count
			str.left_adjust
			tab_count := old_count - str.count
			if tab_count > 0 then
				create old_indent.make_filled ('%T', tab_count + 1)
				old_indent.put ('%N', 1)
				create new_line.make_filled ('%N', 1)
			end
			str.replace_substring_all (old_indent, new_line)
		end

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

	delimited_list (text, delimiter: ASTRING): LIST [ASTRING]
			-- string delimited list
		local
			intervals: EL_DELIMITED_SUBSTRING_INTERVALS
		do
			create intervals.make (text, delimiter)
			Result := intervals.substrings
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

	string_from_general (s: READABLE_STRING_GENERAL): ASTRING
			--
		do
			if attached {ASTRING} s as a_s then
				Result := a_s
			else
				create Result.make_from_unicode (s)
			end
		end

	from_codes (codes: SPECIAL [NATURAL_8]): STRING
		local
			i: INTEGER
		do
			create Result.make (codes.count)
			from i := 0 until i = codes.count loop
				Result.append_code (codes [i])
				i := i + 1
			end
		end

	to_code_array (s: STRING): ARRAY [NATURAL_8]
		local
			i: INTEGER
		do
			create Result.make_filled (0, 1, s.count)
			from i := 1 until i > s.count loop
				Result [i] := s.code (i).to_natural_8
				i := i + 1
			end
		end

feature -- Encoding conversion: STRING_32

	as_utf8 (str: READABLE_STRING_GENERAL): STRING
		do
			if attached {ASTRING} str as l_str then
				Result := l_str.to_utf8
			else
				Result := UTF.utf_32_string_to_utf_8_string_8 (str)
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

feature {NONE} -- Implementation

	Internal_string: ASTRING
			--
		once
			create Result.make_empty
		end

end -- class STRING_ROUTINES
