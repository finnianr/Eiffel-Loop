note
	description: "String routines"

	notes: "[
		Development strategy:
		Migrate these functions into EL_STRING_X_ROUTINES and access via
		EL_MODULE_STRING_8 and EL_MODULE_STRING_32
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 17:07:38 GMT (Saturday 26th December 2015)"
	revision: "1"

class
	EL_STRING_ROUTINES

inherit
	KL_STRING_ROUTINES
		rename
			dummy_string as Empty_string
		export
			{ANY} Empty_string
		redefine
			is_hexadecimal
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
			Result.replace_substring_all (Directory.Working.to_string.to_latin_1, "$CWD")
		end

	indented_text (indent: ZSTRING; text: ZSTRING): ZSTRING
			-- replace new lines in text with indented new lines
		local
			lines: LIST [ZSTRING]
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

	joined_words (strings: INDEXABLE [READABLE_STRING_GENERAL, INTEGER]): ZSTRING
			--
		do
			Result := joined (strings, once " ")
		end

	joined (strings: INDEXABLE [READABLE_STRING_GENERAL, INTEGER]; separator: ZSTRING): ZSTRING
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
				if attached {ZSTRING} item as el_item then
					Result.append (el_item)
				else
					Result.append (create {ZSTRING}.make_from_unicode (item))
				end
				i := i + 1
			end
			Result := Result.twin
		end

	normalized_word_case (text: ZSTRING; minimum_word_count: INTEGER): ZSTRING
			--
		local
			words: EL_ZSTRING_LIST; word: ZSTRING
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

feature -- Hexadecimal conversion

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

	string_from_general (s: READABLE_STRING_GENERAL): ZSTRING
			--
		do
			if attached {ZSTRING} s as a_s then
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

feature -- Encoding conversion: STRING_32

	as_utf8 (str: READABLE_STRING_GENERAL): STRING
		do
			if attached {ZSTRING} str as l_str then
				Result := l_str.to_utf_8
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

feature -- Character editing

	trim_string_to_length (str: STRING; length: INTEGER)
			--
		do
			if str.count > length then
				str.remove_tail (length - str.count)
			end
		end

feature -- Constants

	Blank_character: CHARACTER_8
			--
		once
			Result := {ASCII}.Blank.to_character_8
		end

	Default_character: CHARACTER

feature {NONE} -- Implementation

	Internal_string: ZSTRING
			--
		once
			create Result.make_empty
		end

end -- class STRING_ROUTINES