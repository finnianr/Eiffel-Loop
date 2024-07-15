note
	description: "[
		${EL_STRING_X_ROUTINES} implemented for ${EL_READABLE_ZSTRING}
		plus a few extra convenience routines
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-15 7:31:10 GMT (Monday 15th July 2024)"
	revision: "32"

class
	EL_ZSTRING_ROUTINES_IMP

inherit
	EL_STRING_X_ROUTINES [ZSTRING, EL_READABLE_ZSTRING, CHARACTER_32]
		rename
			to_code as to_z_code,
			ZString_searcher as String_searcher
		undefine
			bit_count
		redefine
			adjusted, to_canonically_spaced, to_z_code, replace_character, translate_with_deletion
		end

	EL_READABLE_STRING_32_ROUTINES [EL_READABLE_ZSTRING]

	EL_SHARED_ESCAPE_TABLE; EL_SHARED_IMMUTABLE_32_MANAGER; EL_SHARED_ZSTRING_BUFFER_SCOPES

	EL_SHARED_ZSTRING_CODEC

	EL_ZSTRING_CONSTANTS

feature -- Factory

	character_string (uc: CHARACTER_32): ZSTRING
		-- shared instance of string with `uc' character
		do
			Result := Character_string_table.item (uc, 1)
		end

	n_character_string (uc: CHARACTER_32; n: INTEGER): ZSTRING
		-- shared instance of string with `n' times `uc' character
		do
			Result := Character_string_table.item (uc, n)
		end

	new_list (comma_separated: ZSTRING): EL_ZSTRING_LIST
		do
			create Result.make_comma_split (comma_separated)
		end

feature -- Comparison

	same_string (a, b: EL_READABLE_ZSTRING): BOOLEAN
		do
			Result := a.same_string (b)
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

	last_word_start_index (str: ZSTRING; end_index_ptr: TYPED_POINTER [INTEGER]): INTEGER
		-- start index of last alpha-numeric word in `str' and end index
		-- written to `end_index_ptr' if not equal to `default_pointer'
		local
			i: INTEGER; found: BOOLEAN; p: EL_POINTER_ROUTINES
		do
			from i := str.count until i = 0 or found loop
				if str.is_alpha_numeric_item (i) then
					if not end_index_ptr.is_default_pointer then
						p.put_integer_32 (i, end_index_ptr)
					end
					found := True
				end
				i := i - 1
			end
			found := False
			from until i = 0 or found loop
				if str.is_alpha_numeric_item (i) then
					Result := i
				else
					found := True
				end
				i := i - 1
			end
		end

feature -- Conversion

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

	shared_substring (s: ZSTRING; new_count: INTEGER): ZSTRING
		-- `s.substring (1, new_count)' with shared area
		do
			create Result.make (0)
			Result.share (s)
			Result.set_count (new_count)
		end

feature -- Character query

	has_enclosing (s: EL_READABLE_ZSTRING; c_first, c_last: CHARACTER_32): BOOLEAN
			--
		do
			if s.count >= 2 then
				if c_first.natural_32_code <= 127 and c_last.natural_32_code <= 127 then
					Result := s.item_8 (1) = c_first and then s.item_8 (s.count) = c_last
				else
					Result := s [1] = c_first and then s [s.count] = c_last
				end
			end
		end

	is_i_th_identifier (str: EL_READABLE_ZSTRING; i: INTEGER): BOOLEAN
		do
			Result := str.is_alpha_numeric_item (i) or else str.item_8 (i) = '_'
		end

	is_punctuation (c: CHARACTER_32): BOOLEAN
		do
			Result := not (c = '$' or c = '_') and then c.is_punctuation
		end

	is_subset_of (str: EL_READABLE_ZSTRING; set: EL_SET [CHARACTER_32]): BOOLEAN
		-- `True' if set of all characters in `str' is a subset of `set'
		do
			Result := str.is_subset_of (set)
		end

feature -- Basic operations

	append_area_32 (str: ZSTRING; area: SPECIAL [CHARACTER_32])
		do
			Immutable_32.set_item (area, 0, area.count)
			str.append_string_general (Immutable_32.item)
		end

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

	prune_all_leading (str: ZSTRING; c: CHARACTER_32)
		do
			str.prune_all_leading (c)
		end

	pruned (str: ZSTRING; c: CHARACTER_32): ZSTRING
		do
			create Result.make_from_string (str)
			Result.prune_all (c)
		end

	replace_character (target: ZSTRING; uc_old, uc_new: CHARACTER_32)
		do
			target.replace_character (uc_old, uc_new)
		end

	to_canonically_spaced (str: ZSTRING)
		do
			str.to_canonically_spaced
		end

	wipe_out (str: ZSTRING)
		do
			str.wipe_out
		end

feature {NONE} -- Implementation

	as_canonically_spaced (s: EL_READABLE_ZSTRING): ZSTRING
		-- copy of `s' with each substring of whitespace consisting of one space character (ASCII 32)
		do
			create Result.make (s.count)
			Result.append (s)
		end

	cursor (s: EL_READABLE_ZSTRING): EL_ZSTRING_ITERATION_CURSOR
		do
			Result := s.new_cursor
		end

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: EL_READABLE_ZSTRING; pattern: READABLE_STRING_GENERAL)
		do
			intervals.fill_by_string (target, pattern, 0)
		end

	last_index_of (str: EL_READABLE_ZSTRING; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		do
			Result := str.last_index_of (c, start_index_from_end)
		end

	is_i_th_alpha (str: EL_READABLE_ZSTRING; i: INTEGER): BOOLEAN
		-- `True' if i'th character is alphabetical
		do
			Result := str.is_alpha_item (i)
		end

	is_i_th_alpha_numeric (str: EL_READABLE_ZSTRING; i: INTEGER): BOOLEAN
		-- `True' if i'th character is alphabetical or numeric
		do
			Result := str.is_alpha_numeric_item (i)
		end

	new_shared_substring (str: EL_READABLE_ZSTRING; start_index, end_index: INTEGER): EL_READABLE_ZSTRING
		do
			Result := Buffer.copied_substring (str, start_index, end_index)
		end

	replace_substring (str: ZSTRING; insert: EL_READABLE_ZSTRING; start_index, end_index: INTEGER)
		do
			str.replace_substring (insert, start_index, end_index)
		end

	to_z_code (character: CHARACTER_32): NATURAL_32
		do
			Result := Codec.as_z_code (character)
		end

	translate_with_deletion (
		target: ZSTRING; old_characters, new_characters: READABLE_STRING_GENERAL; delete_null: BOOLEAN
	)
		do
			if delete_null then
				target.translate_or_delete (old_characters, new_characters)
			else
				target.translate (old_characters, new_characters)
			end
		end

feature {NONE} -- Constants

	Asterisk: CHARACTER_32 = '*'

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

	Split_on_character: EL_SPLIT_ZSTRING_ON_CHARACTER
		once
			create Result.make (Empty_string, '_')
		end

	Substitution_mark_unescaper: EL_ZSTRING_UNESCAPER
		once
			create Result.make (Escape_table.Substitution)
		end

end