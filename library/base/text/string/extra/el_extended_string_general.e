note
	description: "Extended string general"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-27 12:34:58 GMT (Sunday 27th April 2025)"
	revision: "18"

deferred class
	EL_EXTENDED_STRING_GENERAL [CHAR -> COMPARABLE]

inherit
	EL_EXTENDED_READABLE_STRING_I [CHAR]
		rename
			target as shared_string
		undefine
			count, is_valid_as_string_8, valid_index
		end

	EL_SHARED_FILLED_STRING_TABLES

feature -- Duplication

	character_string, filled_1 (c: CHAR): like shared_string
		do
			Result := filled (c, 1)
		end

	enclosed (left, right: CHAR): like shared_string
		-- copy of target with `left' and `right' character prepended and appended
		deferred
		ensure
			definition:
				Result [1] = to_character_32 (left) and Result [Result.count] = to_character_32 (right)
				and Result.substring (2, Result.count - 1) ~ shared_string
		end

	filled (c: CHAR; n: INTEGER): like shared_string
		-- shared string filled with `n' number of `c' characters repeated
		deferred
		ensure
			definition: Result.occurrences (to_character_32 (c)) = n
		end

	pruned (c: CHAR): like shared_string
		deferred
		end

	quoted (type: INTEGER): like shared_string
		require
			type_is_single_double_or_appropriate: 1 <= type and type <= 3
		local
			c: CHAR
		do
			inspect type
				when 1 then
					c := to_char ('%'')

				when 3 then -- appropriate for content
					if has (to_char ('"')) then
						c := to_char ('%'')
					else
						c := to_char ('"')
					end
			else
				c := to_char ('"')
			end
			Result := enclosed (c, c)
		end

feature -- Measurement

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

	shared_leading (end_index: INTEGER): like shared_string
		-- leading substring of `shared_string' from 1 to `end_index'
		require
			valid_count: end_index <= count
		deferred
		end

feature -- Element change

	append_area_32 (a_area: SPECIAL [CHARACTER_32])
		local
			new_count: INTEGER
		do
			if a_area.count > 0 then
				new_count := count + a_area.count
				grow (new_count)
				copy_area_32_data (area, a_area)
				area [new_count] := to_char ('%U')
				set_count (new_count)
				update_shared
			end
		ensure
			valid_count: count = old count + a_area.count
			appended:
				a_area.count > 0 implies shared_string.substring (old count + 1, count).same_string (new_string_32 (a_area))
		end

	append_utf_8 (utf_8: READABLE_STRING_8)
		local
			converter: EL_UTF_8_CONVERTER
		do
			append_area_32 (converter.new_unicode_zero_array (utf_8, 1, utf_8.count))
		end

	first_to_upper
		do
			if count > 0 then
				put_upper (1)
			end
		end

	prune_set_members (set: EL_SET [CHAR])
		local
			i, j, i_upper: INTEGER; c_i: CHAR
		do
			i_upper := count - 1
			if attached area as l_area then
				from until i > i_upper loop
					c_i := l_area [i]
					if not set.has (c_i) then
						l_area [j] := c_i
						j := j + 1
					end
					i := i + 1
				end
			end
			set_count (j)
			update_shared
		end

	put_lower (i: INTEGER)
		require
			valid_index: valid_index (i)
		do
			area [i - 1] := to_lower_case (area [i - 1])
			update_shared -- reset hash
		end

	put_upper (i: INTEGER)
		require
			valid_index: valid_index (i)
		do
			area [i - 1] := to_upper_case (area [i - 1])
			update_shared -- reset hash
		end

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
			set_count (count)
			update_shared
		end

	replace_character (uc_old, uc_new: CHARACTER_32)
		local
			i, i_upper: INTEGER; old_char, new_char: CHAR
		do
			old_char := to_char (uc_old); new_char := to_char (uc_new)
			if attached area as l_area then
				i_upper := count - 1
				from until i > i_upper loop
					if l_area [i] = old_char then
						l_area [i] := new_char
					end
					i := i + 1
				end
			end
		end

	replaced_identifier (old_id, new_id: like READABLE_X): like shared_string
		-- copy of `str' with each each Eiffel identifier `old_id' replaced with `new_id'
		require
			both_identifiers: is_identifier_string (old_id) and is_identifier_string (new_id)
		local
			intervals: EL_OCCURRENCE_INTERVALS; new_count: INTEGER
		do
			Result := shared_string.twin
		-- Important to save `shared_string' first as `intervals.make_by_string' makes call to `set_target'
			create intervals.make_by_string (shared_string, old_id)
			set_target (Result)
			if new_id.count > old_id.count then
				new_count := count + (new_id.count - old_id.count) * intervals.count
				grow (new_count)
			end
			from intervals.finish until intervals.before loop
				if is_identifier_boundary (intervals.item_lower, intervals.item_upper) then
					replace_substring (new_id, intervals.item_lower, intervals.item_upper)
				end
				intervals.back
			end
			set_count (count)
			update_shared
		end

	replace_set_members (set: EL_SET [CHAR]; a_new: CHAR)
		-- Replace all characters that are member of `set' with the `a_new' character
		local
			i, i_upper: INTEGER; c_i: CHAR
		do
			if attached area as l_area then
				i_upper := count - 1
				from i := 0 until i > i_upper loop
					c_i := l_area [i]
					if set.has (c_i) then
						l_area [i] := a_new
					end
					i := i + 1
				end
			end
			update_shared
		end

	set_substring_lower (start_index, end_index: INTEGER)
		do
			set_substring_case (start_index, end_index, {EL_CASE}.Lower)
		end

	set_substring_upper (start_index, end_index: INTEGER)
		do
			set_substring_case (start_index, end_index, {EL_CASE}.Upper)
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

	index_upper: INTEGER
		do
			Result := count - 1
		end

	new_string_32 (a_area: SPECIAL [CHARACTER_32]): STRING_32
		do
			create Result.make_filled (' ', a_area.count)
			Result.area.copy_data (a_area, 0, 0, a_area.count)
		end

	set_substring_case (start_index, end_index: INTEGER; case: NATURAL_8)
		require
			valid_case: is_valid_case (case)
			valid_indices: valid_substring_indices (start_index, end_index)
		local
			i, i_upper: INTEGER
		do
			if attached area as l_area then
				i_upper := end_index - 1
				from i := start_index - 1 until i > i_upper loop
					inspect case
						when {EL_CASE}.Lower then
							l_area [i] := to_lower_case (area [i])

						when {EL_CASE}.Upper then
							l_area [i] := to_upper_case (area [i])
					else
					end
					i := i + 1
				end
			end
		end

	translate_with_deletion (old_characters, new_characters: READABLE_STRING_GENERAL; delete_null: BOOLEAN)
		require
			each_old_has_new: old_characters.count = new_characters.count
		local
			c, new_char, null_char: CHAR; i, j, index, i_upper: INTEGER
		do
			if attached area as l_area then
				null_char := to_char ('%U'); i_upper := count - 1
				from until i > i_upper loop
					c := l_area [i]
					index := old_characters.index_of (to_character_32 (c), 1)
					if index > 0 then
						new_char := to_char (new_characters [index])
						if delete_null implies new_char > null_char then
							l_area [j] := new_char
							j := j + 1
						end
					else
						l_area [j] := c
						j := j + 1
					end
					i := i + 1
				end
				set_count (j); update_shared
			end
		end

feature {EL_EXTENDED_STRING_SELECTION} -- Deferred

	share (other: like shared_string)
		deferred
		end

feature {NONE} -- Deferred

	append_string_general (str: READABLE_STRING_GENERAL)
		deferred
		end

	copy_area_32_data (a_area: like area; source: SPECIAL [CHARACTER_32])
		deferred
		end

	grow (n: INTEGER)
		deferred
		end

	new_substring (start_index, end_index: INTEGER): like shared_string
		deferred
		end

	replace_substring (str: like readable_x; start_index, end_index: INTEGER)
		deferred
		end

	resize (new_size: INTEGER)
		deferred
		end

	set_count (n: INTEGER)
		deferred
		end

	trim
		deferred
		end

	update_shared
		 -- update `shared_string'
		deferred
		end

	wipe_out
		deferred
		end

feature {NONE} -- Constants

	Index_lower: INTEGER	= 0
end