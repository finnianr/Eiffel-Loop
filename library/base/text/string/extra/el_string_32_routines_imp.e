note
	description: "[$source EL_STRING_X_ROUTINES] implemented for [$source READABLE_STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-05 9:33:21 GMT (Saturday 5th November 2022)"
	revision: "29"

class
	EL_STRING_32_ROUTINES_IMP

inherit
	EL_STRING_X_ROUTINES [STRING_32, READABLE_STRING_32]

	EL_SHARED_STRING_32_CURSOR
		rename
			cursor_32 as cursor
		end

feature -- Status query

	is_identifier_character (str: READABLE_STRING_32; i: INTEGER): BOOLEAN
		local
			c: CHARACTER_32
		do
			c := str [i]
			Result := c.is_alpha_numeric or c = '_'
		end

feature -- Comparison

	occurs_at (big, small: READABLE_STRING_32; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index'
		do
			Result := big.same_characters (small, 1, small.count, index)
		end

	occurs_caseless_at (big, small: READABLE_STRING_32; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index' regardless of case
		do
			Result := big.same_caseless_characters (small, 1, small.count, index)
		end

feature -- Basic operations

	append_to (str: STRING_32; extra: READABLE_STRING_GENERAL)
		do
			if attached {ZSTRING} extra as zstr then
				zstr.append_to_string_32 (str)
			else
				str.append_string_general (extra)
			end
		end

	set_upper (str: STRING_32; i: INTEGER)
		do
			str.put (str [i].upper, i)
		end

feature -- Conversion

	from_general (str: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): STRING_32
		local
			buffer: EL_STRING_32_BUFFER_ROUTINES
		do
			if attached {STRING_32} str as str_32 then
				Result := str_32
			else
				Result := buffer.copied_general (str)
				if keep_ref then
					Result := Result.twin
				end
			end
		end

	to_code_array (s: STRING_32): ARRAY [NATURAL_32]
		local
			i: INTEGER
		do
			create Result.make_filled (0, 1, s.count)
			from i := 1 until i > s.count loop
				Result [i] := s.code (i).to_natural_8
				i := i + 1
			end
		end

	to_utf_8 (str: READABLE_STRING_32; keep_ref: BOOLEAN): STRING
		local
			c: EL_UTF_CONVERTER; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			Result := buffer.empty
			c.utf_32_string_into_utf_8_string_8 (str, Result)
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- Factory

	character_string (uc: CHARACTER_32): STRING_32
		-- shared instance of string with `uc' character
		do
			Result := n_character_string (uc, 1)
		end

	n_character_string (uc: CHARACTER_32; n: INTEGER): STRING_32
		-- shared instance of string with `n' times `uc' character
		do
			Result := Character_string_table.item (uc, n)
		end

	new_list (n: INTEGER): EL_STRING_32_LIST
		do
			create Result.make (n)
		end

	shared_substring (s: STRING_32; new_count: INTEGER): STRING_32
		do
			create Result.make (0)
			Result.share (s)
			Result.set_count (new_count)
		end

feature -- Adjust

	left_adjust (str: STRING_32)
		do
			str.left_adjust
		end

	pruned (str: STRING_32; c: CHARACTER_32): STRING_32
		do
			create Result.make_from_string (str)
			Result.prune_all (c)
		end

	prune_all_leading (str: STRING_32; c: CHARACTER_32)
		do
			str.prune_all_leading (c)
		end

	right_adjust (str: STRING_32)
		do
			str.right_adjust
		end

	wipe_out (str: STRING_32)
		do
			str.wipe_out
		end

feature {NONE} -- Implementation

	last_index_of (str: READABLE_STRING_32; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		do
			Result := str.last_index_of (c, start_index_from_end)
		end

feature {NONE} -- Constants

	Character_string_table: EL_FILLED_STRING_32_TABLE
		once
			create Result.make
		end

end