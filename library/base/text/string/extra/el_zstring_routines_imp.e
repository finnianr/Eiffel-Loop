note
	description: "[
		[$source EL_STRING_X_ROUTINES] implemented for [$source EL_READABLE_ZSTRING]
		plus a few extra convenience routines
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_ZSTRING_ROUTINES_IMP

inherit
	EL_STRING_X_ROUTINES [ZSTRING, EL_READABLE_ZSTRING]
		redefine
			adjusted
		end

	EL_MODULE_REUSEABLE

	STRING_HANDLER

feature -- Measurement

	word_count (a_str: ZSTRING; exclude_variable_references: BOOLEAN): INTEGER
		-- count of all words in canonically spaced `a_str', but excluding words that
		-- are substitution references if `exclude_variable_references' is `True'
		local
			str: ZSTRING
		do
			across Reuseable.string as reuse loop
				if a_str.is_canonically_spaced then
					str := a_str
				else
					str := reuse.item
					str.append (a_str)
					str.to_canonically_spaced
				end
				across str.split (' ') as word loop
					if exclude_variable_references implies not is_variable_reference (word.item) then
						Result := Result + 1
					end
				end
			end
		end

feature -- Factory

	character_string (uc: CHARACTER_32): ZSTRING
		-- shared instance of string with `uc' character
		do
			Result := n_character_string (uc, 1)
		end

	n_character_string (uc: CHARACTER_32; n: INTEGER): ZSTRING
		-- shared instance of string with `n' times `uc' character
		do
			Result := Character_string_table.item (uc, n)
		ensure
			valid_result: Result.occurrences (uc) = n.to_integer_32
		end

	new_list (n: INTEGER): EL_ZSTRING_LIST
		do
			create Result.make (n)
		end

feature -- Comparison

	occurs_at (big, small: EL_READABLE_ZSTRING; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index'
		do
			Result := big.same_characters (small, 1, small.count, index)
		end

	occurs_caseless_at (big, small: EL_READABLE_ZSTRING; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index' regardless of case
		do
			Result := big.same_caseless_characters (small, 1, small.count, index)
		end

feature -- Substring

	adjusted (str: EL_READABLE_ZSTRING): EL_READABLE_ZSTRING
		local
			start_index, end_index: INTEGER
		do
			end_index := str.count - str.trailing_white_space
			if end_index.to_boolean then
				start_index := str.leading_white_space + 1
			else
				start_index := 1
			end
			if start_index = 1 and then end_index = str.count then
				Result := str
			else
				Result := str.substring (start_index, end_index)
			end
		end

	last_word (str: ZSTRING): ZSTRING
		-- last alpha-numeric word in `str'
		local
			i: INTEGER
		do
			create Result.make (20)
			from i := str.count until i < 1 or else str.is_alpha_numeric_item (i) loop
				i := i - 1
			end
			from until i < 1 or else not str.is_alpha_numeric_item (i) loop
				Result.append_character (str.item (i))
				i := i - 1
			end
			Result.mirror
		end

feature -- Conversion

	as_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		do
			if attached {ZSTRING} general as str then
				Result := str
			else
				create Result.make_from_general (general)
			end
		end

	from_general (str: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): ZSTRING
		local
			buffer: EL_ZSTRING_BUFFER_ROUTINES
		do
			if attached {ZSTRING} str as z_str then
				Result := z_str
			else
				Result := buffer.copied_general (str)
				if keep_ref then
					Result := Result.twin
				end
			end
		end

	joined (separator: CHARACTER_32; a_list: ITERABLE [READABLE_STRING_GENERAL]): ZSTRING
		local
			count: INTEGER
		do
			across a_list as list loop
				if count > 0 then
					count := count + 1
				end
				count := count + list.item.count
				list.forth
			end
			create Result.make (count)
			across a_list as list loop
				if Result.count > 0 then
					Result.append_character (separator)
				end
				if attached {ZSTRING} list.item as zstr then
					Result.append (zstr)
				else
					Result.append_string_general (list.item)
				end
			end
		end

	new_paragraph_list (text: READABLE_STRING_GENERAL): EL_ZSTRING_LIST
		-- `text' lines joined together as paragraphs with
		-- an empty line interpreted as a paragraph delimiter
		local
			lines, sub_list: EL_ZSTRING_LIST
		do
			create lines.make_with_lines (text)

			create Result.make (lines.count_of (agent {ZSTRING}.is_empty) + 1)
			create sub_list.make (lines.count // Result.capacity + 1)
			across lines as l loop
				if not l.item.is_empty then
					sub_list.extend (l.item)
				end
				if l.item.is_empty or l.is_last then
					Result.extend (sub_list.joined (' '))
					sub_list.wipe_out
				end
			end
		end

	new_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (general)
		end

	to_unicode_general (general: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			if attached {ZSTRING} general as zstr then
				Result := zstr.to_unicode
			else
				Result := general
			end
		end

	shared_substring (s: ZSTRING; new_count: INTEGER): ZSTRING
		do
			create Result.make (0)
			Result.share (s)
			Result.set_count (new_count)
		end

feature -- Status query

	has_alpha_numeric (str: ZSTRING): BOOLEAN
		-- `True' if `str' has an alpha numeric character
		local
			i: INTEGER
		do
			from i := 1 until Result or i > str.count loop
				Result := str.is_alpha_numeric_item (i)
				i := i + 1
			end
		end

	is_identifier_character (str: EL_READABLE_ZSTRING; i: INTEGER): BOOLEAN
		do
			Result := str.is_alpha_numeric_item (i) or else str.item_8 (i) = '_'
		end

	is_punctuation (c: CHARACTER_32): BOOLEAN
		do
			Result := not (c = '$' or c = '_') and then c.is_punctuation
		end

	is_variable_name (str: ZSTRING): BOOLEAN
		local
			i: INTEGER
		do
			Result := str.count > 1
			from i := 1 until not Result or i > str.count loop
				inspect i
					when 1 then
						Result := str [i] = '$'
					when 2 then
						Result := str.is_alpha_item (i)
				else
					Result := str.is_alpha_numeric_item (i) or else str [i] = '_'
				end
				i := i + 1
			end
		end

	is_variable_reference (str: ZSTRING): BOOLEAN
		-- `True' if str is one of two variable reference forms

		-- 1. $<C identifier>
		-- 2. ${<C identifier>}
		local
			character_range: detachable INTEGER_INTERVAL
		do
			if str.count >= 2 and then str [1] = '$' then
				if str.is_alpha_item (2) then
					character_range := 3 |..| str.count

				elseif str.count > 3 and then str [2] = '{' and str [str.count] = '}' then
					-- variable like: ${name}
					character_range := 3 |..| str.count
				end
				if attached character_range as range then
					Result := across range as index all
						str.is_alpha_numeric_item (index.item) or else str [index.item] = '_'
					end
				end
			end
		end

	starts_with (a, b: ZSTRING): BOOLEAN
		do
			Result := a.starts_with (b)
		end

	starts_with_drive (str: ZSTRING): BOOLEAN
		do
			inspect str.count
				when 0, 1 then
			else
				Result := str [2] = ':' and then str.is_alpha_item (1)
			end
		end

feature -- Basic operations

	append_to (str: ZSTRING; extra: READABLE_STRING_GENERAL)
		do
			str.append_string_general (extra)
		end

	set_upper (str: ZSTRING; i: INTEGER)
		do
			str.put (str [i].upper, i)
		end

	unescape_substitution_marks (target: ZSTRING)
		-- replace "%S" substrings with '%S'
		do
			if target.has ('%%') then
				target.unescape (Substitution_mark_unescaper)
			end
		end

feature -- Adjust

	left_adjust (str: ZSTRING)
		do
			str.left_adjust
		end

	pruned (str: ZSTRING; c: CHARACTER_32): ZSTRING
		do
			create Result.make_from_string (str)
			Result.prune_all (c)
		end

	prune_all_leading (str: ZSTRING; c: CHARACTER_32)
		do
			str.prune_all_leading (c)
		end

	right_adjust (str: ZSTRING)
		do
			str.right_adjust
		end

	wipe_out (str: ZSTRING)
		do
			str.wipe_out
		end

feature {NONE} -- Implementation

	cursor (s: EL_READABLE_ZSTRING): EL_ZSTRING_ITERATION_CURSOR
		do
			Result := s.new_cursor
		end

	last_index_of (str: EL_READABLE_ZSTRING; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		do
			Result := str.last_index_of (c, start_index_from_end)
		end

feature {NONE} -- Constants

	Character_string_table: EL_FILLED_ZSTRING_TABLE
		once
			create Result.make
		end

	Substitution_mark_unescaper: EL_ZSTRING_UNESCAPER
		local
			table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create table.make_equal (3)
			table ['S'] := '%S'
			create Result.make ('%%', table)
		end

end