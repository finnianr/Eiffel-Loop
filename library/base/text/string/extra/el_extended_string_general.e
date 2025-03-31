note
	description: "Extended string general"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-31 13:51:04 GMT (Monday 31st March 2025)"
	revision: "2"

deferred class
	EL_EXTENDED_STRING_GENERAL [CHAR -> COMPARABLE]

inherit
	EL_BIT_COUNTABLE

	EL_SHARED_UNICODE_PROPERTY

	EL_STRING_HANDLER

feature -- Measurement

	count: INTEGER
		deferred
		end

	occurrences (c: CHAR): INTEGER
		deferred
		end

feature -- Status query

	is_canonically_spaced: BOOLEAN
		-- `True' if the longest substring of whitespace consists of one space character (ASCII 32)
		local
			c_i, space: CHAR; i, i_final, space_count: INTEGER; is_space: BOOLEAN
		do
			space := to_char (' ')
			if attached area as l_area and then attached Unicode_property as unicode then
				Result := True; i_final := count
				from i := 0 until not Result or else i = i_final loop
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

	is_variable_reference: BOOLEAN
		-- `True' if `Current' is one of two variable reference forms

		-- 1. $<C identifier>
		-- 2. ${<C identifier>}
		local
			lower, upper, i: INTEGER; dollor, left_brace, right_brace, underscore: CHAR
		do
			dollor := to_char ('$'); left_brace := to_char ('{'); right_brace := to_char ('}')
			underscore  := to_char ('_')
			upper := count - 1
			if attached area as l_area and then count >= 2 and then l_area [0] = dollor then
				if l_area [1] = left_brace and then upper > 2 then
				-- like: ${name}
					if l_area [upper] = right_brace then
						lower := 2; upper := upper - 1
					end
				else
					lower := 1
				end
				if valid_index (lower + 1) then
					Result := is_i_th_alpha (l_area, lower)
					from i := lower until i > upper or not Result loop
						Result := is_i_th_alpha_numeric (l_area, i) or else l_area [i] = underscore
						i := i + 1
					end
				end
			end
		end

	valid_index (i: INTEGER): BOOLEAN
		-- Is `i' within the bounds of the string?
		deferred
		end

feature -- Enclosure query

	has_double: BOOLEAN
			--
		do
			Result := has_quotes (2)
		end

	has_enclosing (left, right: CHAR): BOOLEAN
			--
		do
			if count >= 2 and then attached area as l_area then
				Result := l_area [0] = left and then l_area [count - 1] = right
			end
		end

	has_quotes (type: INTEGER): BOOLEAN
		require
			double_or_single: type = 2 or type = 1
		local
			c: CHAR
		do
			inspect type
				when 1 then
					c := to_char ('%'')
				when 2 then
					c := to_char ('"')
			else
			end
			Result := has_enclosing (c, c)
		end

	has_single: BOOLEAN
			--
		do
			Result := has_quotes (1)
		end

feature -- Substring

	selected_substring (n: INTEGER; n_set: READABLE_INDEXABLE [INTEGER]): like shared_string
		require
			name_count_matches: n_set.upper - n_set.lower = occurrences (to_char (','))
		local
			index, i, start_index, end_index: INTEGER; found: BOOLEAN; space: CHAR
		do
			if count = 0 then
				Result := new_substring (1, 0)
			else
				from index := n_set.lower until index > n_set.upper or found loop
					if n_set [index] = n then
						found := True
					else
						index := index + 1
					end
				end
				if found and then attached split_on_character (to_char (',')) as split_list then
					found := False
					i := n_set.lower
					if attached area as l_area then
						space := to_char (' ')
						across split_list as list until found loop
							if i = index then
								start_index := list.item_lower; end_index := list.item_upper
								if l_area [start_index - 1] = space then
									start_index :=  start_index + 1
								end
								found := True
							else
								i := i + 1
							end
						end
					end
					if found then
						Result := new_substring (start_index, end_index)
					else
						Result := new_substring (1, 0)
					end
				else
					Result := new_substring (1, 0)
				end
			end
		end

feature -- Element change

	remove_bookends (left, right: CHAR)
		do
			if count >= 2 and then attached area as l_area
				and then l_area [0] = left and then l_area [count - 1] = right
			then
				set_count (count - 2)
				l_area.move_data (1, 0, count)
			end
			update_shared
		end

	remove_double
		local
			c: CHAR
		do
			c := to_char ('"')
			remove_bookends (c, c)
		end

	remove_single
		local
			c: CHAR
		do
			c := to_char ('%'')
			remove_bookends (c, c)
		end

	replace (content: READABLE_STRING_GENERAL)
		-- replace all characters of `str' wih new `content'
		do
			wipe_out; append_string_general (content)
			update_shared
		end

	replace_character (uc_old, uc_new: CHARACTER_32)
		local
			i, upper: INTEGER; old_char, new_char: CHAR
		do
			old_char := to_char (uc_old); new_char := to_char (uc_new)
			if attached area as l_area then
				upper := count - 1
				from until i > upper loop
					if l_area [i] = old_char then
						l_area [i] := new_char
					end
					i := i + 1
				end
			end
		end

	to_canonically_spaced
		-- adjust string so that `is_canonically_spaced' becomes true
		local
			c_i, space: CHAR; i, j, l_count, space_count: INTEGER
		do
			if not is_canonically_spaced and then attached area as l_area and then attached Unicode_property as unicode then
				space := to_char (' '); l_count := count
				from i := 0; j := 0 until i = l_count loop
					c_i := l_area [i]
					if is_i_th_space (l_area, i, unicode) then
						space_count := space_count + 1
					else
						space_count := 0
					end
					inspect space_count
						when 0 then
							l_area [j] := c_i
							j := j + 1

						when 1 then
							l_area [j] := space
							j := j + 1
					else
					end
					i := i + 1
				end
				set_count (j)
				update_shared
				if l_count > 50 and then ((i - j) * 100.0 / l_count).rounded > 15 then
					trim -- reallocate to new size
				end
			end
		ensure
			canonically_spaced: is_canonically_spaced
		end

	translate (old_characters, new_characters: READABLE_STRING_GENERAL)
		-- replace all characters in `old_characters' with corresponding character in `new_characters'.
		do
			translate_with_deletion (old_characters, new_characters, False)
		end

	translate_or_delete (old_characters, new_characters: READABLE_STRING_GENERAL)
		-- replace all characters in `old_characters' with corresponding character in `new_characters'.
		-- and removing any characters corresponding to null value '%U'
		do
			translate_with_deletion (old_characters, new_characters, True)
		end

feature -- Contract Support

	to_char (uc: CHARACTER_32): CHAR
		deferred
		end

feature {NONE} -- Implementation

	translate_with_deletion (old_characters, new_characters: READABLE_STRING_GENERAL; delete_null: BOOLEAN)
		require
			each_old_has_new: old_characters.count = new_characters.count
		local
			c, new_char, null: CHAR; i, j, index, upper: INTEGER
		do
			if attached area as l_area then
				null := to_char ('%U')
				from upper := count - 1 until i > upper loop
					c := l_area [i]
					index := old_characters.index_of (to_character_32 (c), 1)
					if index > 0 then
						new_char := to_char (new_characters [index])
						if delete_null implies new_char > null then
							l_area [j] := new_char
							j := j + 1
						end
					else
						l_area [j] := c
						j := j + 1
					end
					i := i + 1
				end
				set_count (j)
				update_shared
			end
		end

feature {NONE} -- Deferred

	area: SPECIAL [CHAR]
		deferred
		end

	append_string_general (str: READABLE_STRING_GENERAL)
		deferred
		end

	is_i_th_alpha (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area' is alphabetical
		deferred
		end

	is_i_th_alpha_numeric (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area'  is alphabetical or numeric
		deferred
		end

	is_i_th_space (a_area: like area; i: INTEGER; unicode: EL_UNICODE_PROPERTY): BOOLEAN
		-- `True' if i'th character in `a_area'  is white space
		deferred
		end

	new_substring (start_index, end_index: INTEGER): like shared_string
		deferred
		end

	set_count (n: INTEGER)
		deferred
		end

	shared_string: STRING_GENERAL
		deferred
		end

	split_on_character (separator: CHAR): EL_SPLIT_ON_CHARACTER [like shared_string]
		deferred
		end

	trim
		 -- reallocate to new size
		deferred
		end

	to_character_32 (c: CHAR): CHARACTER_32
		deferred
		end

	update_shared
		deferred
		end

	wipe_out
		deferred
		end

feature {NONE} -- Type definitions

	READABLE: READABLE_STRING_GENERAL
		require
			never_called: False
		deferred
		end
end