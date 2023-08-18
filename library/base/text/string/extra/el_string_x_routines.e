note
	description: "Routines to supplement handling of [$source STRING_8] [$source STRING_32] strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-18 10:48:55 GMT (Friday 18th August 2023)"
	revision: "54"

deferred class
	EL_STRING_X_ROUTINES [STRING_X -> STRING_GENERAL create make end, READABLE_STRING_X -> READABLE_STRING_GENERAL]

inherit
	EL_READABLE_STRING_X_ROUTINES [READABLE_STRING_X]

feature -- Basic operations

	append_area_32 (str: STRING_X; area: SPECIAL [CHARACTER_32])
		deferred
		end

	append_to (str: STRING_X; extra: READABLE_STRING_GENERAL)
		deferred
		end

	set_upper (str: STRING_X; i: INTEGER)
		require
			valid_index: 0 < i and i <= str.count
		deferred
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

	new_list (n: INTEGER): EL_STRING_LIST [STRING_X]
		deferred
		end

	shared_substring (s: STRING_X; new_count: INTEGER): STRING_X
		require
			valid_count: new_count <= s.count
		deferred
		end

	spaces (width, count: INTEGER): STRING_X
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

feature -- Transformed

	curtailed (str: READABLE_STRING_X; max_count: INTEGER): READABLE_STRING_X
		-- `str' curtailed to `max_count' with added ellipsis where `max_count' is exceeded
		do
			if str.count > max_count - 2 then
				Result := str.substring (1, max_count - 2) + Character_string_8_table.item ('.', 2)
			else
				Result := str
			end
		end

	enclosed (str: READABLE_STRING_GENERAL; left, right: CHARACTER_32): STRING_X
			--
		do
			create Result.make (str.count + 2)
			Result.append_code (left.natural_32_code)
			append_to (Result, str)
			Result.append_code (right.natural_32_code)
		end

	joined (a, b: READABLE_STRING_X): STRING_X
		do
			create Result.make (a.count + b.count)
			Result.append (a); Result.append (b)
		end

	joined_lines (list: ITERABLE [READABLE_STRING_GENERAL]): STRING_X
		do
			Result := joined_by (list, '%N')
		end

	joined_by (list: ITERABLE [READABLE_STRING_GENERAL]; delimiter: CHARACTER_32): STRING_X
		local
			char_count: INTEGER; code: NATURAL_32
		do
			code := delimiter.natural_32_code
			char_count := character_count (list, 1)
			create Result.make (char_count)
			across list as ln loop
				if Result.count > 0 then
					Result.append_code (code)
				end
				append_to (Result, ln.item)
			end
		end

	joined_with (list: ITERABLE [READABLE_STRING_GENERAL]; delimiter: READABLE_STRING_GENERAL): STRING_X
		local
			char_count: INTEGER
		do
			char_count := character_count (list, delimiter.count)
			create Result.make (char_count)
			across list as ln loop
				if Result.count > 0 then
					append_to (Result, delimiter)
				end
				append_to (Result, ln.item)
			end
		end

	leading_delimited (text, delimiter: STRING_X; include_delimiter: BOOLEAN): STRING_X
			--
		do
			if attached Shared_intervals as intervals then
				intervals.wipe_out
				intervals.fill_by_string (text, delimiter, 0)
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
			if quote_type = 1 then
				c := '%''
			else
				c := '"'
			end
			Result := enclosed (str, c, c)
		end

	replace (str: STRING_X; content: READABLE_STRING_GENERAL)
		-- replace all characters of `str' wih new `content'
		do
			wipe_out (str)
			append_to (str, content)
		end

	unbracketed (str: READABLE_STRING_GENERAL; left_bracket: CHARACTER_32): STRING_X
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

feature -- Adjust

	left_adjust (str: STRING_X)
		deferred
		end

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

	right_adjust (str: STRING_X)
		deferred
		end

	wipe_out (str: STRING_X)
		deferred
		end

feature -- Transform

	first_to_upper (str: STRING_GENERAL)
		do
			if not str.is_empty then
				str.put_code (str.item (1).as_upper.natural_32_code, 1)
			end
		end

	replace_character (target: STRING_X; uc_old, uc_new: CHARACTER_32)
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

	translate (target, old_characters, new_characters: STRING_X)
		do
			translate_deleting_null_characters (target, old_characters, new_characters, False)
		end

	translate_and_delete (target, old_characters, new_characters: STRING_X)
		do
			translate_deleting_null_characters (target, old_characters, new_characters, True)
		end

	translate_deleting_null_characters (target, old_characters, new_characters: STRING_X; delete_null: BOOLEAN)
		require
			each_old_has_new: old_characters.count = new_characters.count
		local
			source: STRING_X; c, new_c: CHARACTER_32; i, index: INTEGER
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

end