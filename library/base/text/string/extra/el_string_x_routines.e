note
	description: "Routines to supplement handling of ${STRING_8} ${STRING_32} strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-23 17:46:35 GMT (Sunday 23rd February 2025)"
	revision: "77"

deferred class
	EL_STRING_X_ROUTINES [
		STRING_X -> STRING_GENERAL create make end, READABLE_STRING_X -> READABLE_STRING_GENERAL,
		C -> COMPARABLE -- CHARACTER_X
	]

inherit
	EL_READABLE_STRING_X_ROUTINES [READABLE_STRING_X, C]

feature -- Basic operations

	replace (str: STRING_X; content: READABLE_STRING_GENERAL)
		-- replace all characters of `str' wih new `content'
		do
			wipe_out (str)
			append_to (str, content)
		end

feature -- Factory

	character_string (uc: CHARACTER_32): STRING_X
		-- shared instance of string with `uc' character
		deferred
		end

	n_character_string (uc: CHARACTER_32; n: INTEGER): STRING_X
		-- shared instance of string with `n' times `uc' character
		deferred
		ensure
			valid_result: Result.occurrences (uc) = n.to_integer_32
		end

	new (n: INTEGER): STRING_X
			-- width * count spaces
		do
			create Result.make (n)
		end

	new_from_string_8 (str: READABLE_STRING_8; utf_8_encoded: BOOLEAN): STRING_X
		local
			u8: EL_UTF_8_CONVERTER
		do
			if utf_8_encoded then
				create Result.make (u8.unicode_count (str))
				append_utf_8_to (str, Result)
			else
				Result := new (str.count)
				Result.append (str)
			end
		end

	new_from_immutable_8 (
		str: IMMUTABLE_STRING_8; start_index, end_index: INTEGER_32; unindent, utf_8_encoded: BOOLEAN

	): STRING_X
		-- new string of type `STRING_X' consisting of decoded UTF-8 text

		--		`str.shared_substring (start_index, end_index)'

		-- if `unindent' is true, and character at `start_index' is a tab, then all lines
		-- are unindented by one tab.
		require
			valid_start_index: str.valid_index (start_index)
			valid_end_index: end_index >= start_index implies str.valid_index (end_index)
		local
			split_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			if end_index - start_index + 1 = 0 then
				create Result.make (0)

			elseif unindent and then str [start_index] = '%T' then
				if attached str.shared_substring (start_index + 1, end_index) as lines then
					if lines.has ('%N') then
						if utf_8_encoded then
							split_list := Immutable_utf_8_list
						else
							split_list := Immutable_latin_1_list
						end
						split_list.fill_by_string (lines, New_line_tab, 0)
						if split_list.count > 0 then
							create Result.make (split_list.unicode_count + split_list.count - 1)
							split_list.append_lines_to (Result)
						end
					else
						Result := new_from_string_8 (lines, utf_8_encoded)
					end
				end
			else
				Result := new_from_string_8 (str.shared_substring (start_index, end_index), utf_8_encoded)
			end
		ensure
			calculated_correct_size: Result.count = Result.capacity
		end

	new_list (comma_separated: STRING_X): EL_STRING_LIST [STRING_X]
		deferred
		end

	new_retrieved (file_path: FILE_PATH): STRING_X
		-- new instace of type `STRING_X' restored from file saved by Studio debugger
		local
			file: RAW_FILE
		do
			create file.make_open_read (file_path)
			if attached {STRING_X} file.retrieved as debug_str then
				Result := debug_str
			else
				Result := new (0)
			end
			file.close
		end

	shared_substring (s: STRING_X; new_count: INTEGER): STRING_X
		-- `s.substring (1, new_count)' with shared area
		require
			valid_count: new_count <= s.count
		deferred
		end

feature -- List joining

	joined (a, b: READABLE_STRING_X): STRING_X
		do
			create Result.make (a.count + b.count)
			append_to (Result, a); append_to (Result, b)
		end

	joined_lines (list: ITERABLE [READABLE_STRING_GENERAL]): STRING_X
		do
			Result := joined_list (list, '%N')
		end

	joined_list (list: ITERABLE [READABLE_STRING_GENERAL]; separator: CHARACTER_32): STRING_X
		local
			char_count: INTEGER; code: NATURAL_32
		do
			code := to_code (separator) -- might be z_code for ZSTRING
			char_count := character_count (list, 1)
			create Result.make (char_count)
			across list as ln loop
				if Result.count > 0 then
					Result.append_code (code)
				end
				append_to (Result, ln.item)
			end
		end

	joined_list_with (list: ITERABLE [READABLE_STRING_GENERAL]; separator: READABLE_STRING_GENERAL): STRING_X
		local
			char_count: INTEGER
		do
			char_count := character_count (list, separator.count)
			create Result.make (char_count)
			across list as ln loop
				if Result.count > 0 then
					append_to (Result, separator)
				end
				append_to (Result, ln.item)
			end
		end

	joined_with (a, b, separator: READABLE_STRING_X): STRING_X
		do
			create Result.make (a.count + b.count + separator.count)
			append_to (Result, a); append_to (Result, separator); append_to (Result, b)
		end

feature -- Transformed

	enclosed (str: READABLE_STRING_GENERAL; left, right: CHARACTER_32): STRING_X
			--
		do
			create Result.make (str.count + 2)
			Result.append_code (to_code (left))
			append_to (Result, str)
			Result.append_code (to_code (right))
		end

	leading_delimited (text, delimiter: STRING_X; include_delimiter: BOOLEAN): STRING_X
			--
		do
			if attached Shared_intervals as intervals then
				intervals.wipe_out
				intervals.fill_by_string_general (text, delimiter, 0)
				intervals.start
				if intervals.after then
					create Result.make (0)
				else
					if include_delimiter then
						Result := text.substring (1, intervals.item_upper)
					else
						Result := text.substring (1, intervals.item_lower - 1)
					end
				end
			else
				create Result.make (0)
			end
		end

	pruned (str: READABLE_STRING_GENERAL; c: CHARACTER_32): STRING_X
		deferred
		end

	quoted (str: READABLE_STRING_GENERAL; quote_type: INTEGER): STRING_X
		require
			single_or_double: (1 |..| 2).has (quote_type)
		local
			c: CHARACTER
		do
			inspect quote_type
				when 1 then
					c := '%''
			else
				c := '"'
			end
			Result := enclosed (str, c, c)
		end

	replaced_identifier (str, old_id, new_id: READABLE_STRING_X): STRING_X
		-- copy of `str' with each each Eiffel identifier `old_id' replaced with `new_id'
		require
			both_identifiers: is_eiffel (old_id) and is_eiffel (new_id)
		local
			intervals: EL_OCCURRENCE_INTERVALS
		do
			create intervals.make_by_string (str, old_id)
			if new_id.count > old_id.count then
				Result := new (str.count + (new_id.count - old_id.count) * intervals.count)
			else
				Result := new (str.count)
			end
			Result.append (str)
			from intervals.finish until intervals.before loop
				if is_identifier_boundary (str, intervals.item_lower, intervals.item_upper) then
					replace_substring (Result, new_id, intervals.item_lower, intervals.item_upper)
				end
				intervals.back
			end
		end

feature -- Adjust

	prune_all_leading (str: STRING_X; c: CHARACTER_32)
		deferred
		end

	remove_bookends (str: STRING_X; ends: READABLE_STRING_GENERAL)
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

	remove_double_quote (quoted_str: STRING_X)
			--
		do
			remove_bookends (quoted_str, once "%"%"" )
		end

	remove_single_quote (quoted_str: STRING_X)
			--
		do
			remove_bookends (quoted_str, once "''" )
		end

	to_canonically_spaced (str: STRING_X)
		-- adjust string so that `is_canonically_spaced' becomes true
		local
			uc_i: CHARACTER_32; i, j, upper, space_count: INTEGER
			c32: EL_CHARACTER_32_ROUTINES
		do
			if attached {READABLE_STRING_X} str as s and then not is_canonically_spaced (s) then
				upper := str.count
				from i := 1; j := 1 until i > upper loop
					uc_i := str [i]
					if c32.is_space (uc_i) then
						space_count := space_count + 1
					else
						space_count := 0
					end
					inspect space_count
						when 0 then
							str.put_code (uc_i.natural_32_code, j)
							j := j + 1

						when 1 then
							str.put_code ({EL_ASCII}.space, j)
							j := j + 1
					else
					end
					i := i + 1
				end
				str.keep_head (j - 1)
			end
		end

	wipe_out (str: STRING_X)
		deferred
		end

feature -- Transform

	first_to_upper (str: STRING_GENERAL)
		do
			if not str.is_empty then
				str.put_code (to_code (str.item (1).as_upper), 1)
			end
		end

	replace_character (target: STRING_X; uc_old, uc_new: CHARACTER_32)
		local
			i: INTEGER; code_old, code_new: NATURAL
		do
			code_old := to_code (uc_old); code_new := to_code (uc_new)
			from i := 1 until i > target.count loop
				if target.code (i) = code_old then
					target.put_code (code_new, i)
				end
				i := i + 1
			end
		end

	translate (target: STRING_X; old_characters, new_characters: READABLE_STRING_GENERAL)
		-- replace all characters in `old_characters' with corresponding character in `new_characters'.
		do
			translate_with_deletion (target, old_characters, new_characters, False)
		end

	translate_or_delete (target: STRING_X; old_characters, new_characters: READABLE_STRING_GENERAL)
		-- replace all characters in `old_characters' with corresponding character in `new_characters'.
		-- and removing any characters corresponding to null value '%U'
		do
			translate_with_deletion (target, old_characters, new_characters, True)
		end

feature {NONE} -- Implementation

	translate_with_deletion (
		target: STRING_X; old_characters, new_characters: READABLE_STRING_GENERAL; delete_null: BOOLEAN
	)
		require
			each_old_has_new: old_characters.count = new_characters.count
		local
			source: STRING_X; uc: CHARACTER_32; i, index: INTEGER
			new_code: NATURAL
		do
			source := target.twin
			target.set_count (0)
			from i := 1 until i > source.count loop
				uc := source [i]
				index := old_characters.index_of (uc, 1)
				if index > 0 then
					new_code := to_code (new_characters [index])
					if delete_null implies new_code > 0 then
						target.append_code (new_code)
					end
				else
					target.append_code (to_code (uc))
				end
				i := i + 1
			end
		end

feature {NONE} -- Deferred

	append_area_32 (str: STRING_X; area: SPECIAL [CHARACTER_32])
		deferred
		end

	append_utf_8_to (utf_8: READABLE_STRING_8; output: STRING_X)
		deferred
		end

	append_to (str: STRING_X; extra: READABLE_STRING_GENERAL)
		deferred
		end

	replace_substring (str: STRING_X; insert: READABLE_STRING_X; start_index, end_index: INTEGER)
		deferred
		end

	set_upper (str: STRING_X; i: INTEGER)
		require
			valid_index: 0 < i and i <= str.count
		deferred
		end

feature {NONE} -- Constants

	New_line_tab: STRING = "%N%T"

	Immutable_utf_8_list: EL_SPLIT_IMMUTABLE_UTF_8_LIST
		once
			create Result.make_empty
		end

	Immutable_latin_1_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		once
			create Result.make_empty
		end

end