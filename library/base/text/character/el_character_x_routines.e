note
	description: "Base class for ${EL_CHARACTER_8_ROUTINES} and ${EL_CHARACTER_32_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-12 7:55:27 GMT (Saturday 12th April 2025)"
	revision: "40"

deferred class
	EL_CHARACTER_X_ROUTINES [CHAR -> COMPARABLE]

inherit
	EL_BIT_COUNTABLE

	EL_CASE_CONTRACT

feature -- Access

	right_bracket (left_bracket: CHAR): CHAR
		require
			is_left: is_left_bracket (left_bracket)
		do
			Result := shifted_character (left_bracket, right_bracket_offset (left_bracket))
		end

	right_bracket_index (area: SPECIAL [CHAR]; left_bracket: CHAR; start_index, end_index: INTEGER): INTEGER
		-- index of right bracket corresponding to `left_bracket'. `-1' if not found.
		local
			i, nest_count: INTEGER; c, l_right_bracket: CHAR; found: BOOLEAN
		do
			l_right_bracket := right_bracket (left_bracket)
			from i := start_index until found or i > end_index loop
				c := area [i]
				if c = left_bracket then
					nest_count := nest_count + 1
				else
					inspect nest_count
						when 0 then
							if c = l_right_bracket then
								found := True
							end
					else
						if c = l_right_bracket then
							nest_count := nest_count - 1
						end
					end
				end
				i := i + 1
			end
			if found then
				Result := i - 1
			else
				Result := i.one.opposite
			end
		end

feature -- Status query

	has_member (set: EL_SET [CHAR]; area: SPECIAL [CHAR]; start_index, end_index: INTEGER): BOOLEAN
		-- `True' at least one character in `area' between `start_index' to `end_index'
		-- is a member of `set'
		local
			i: INTEGER
		do
			from i := start_index until Result or i > end_index loop
				if set.has (area [i]) then
					Result := True
				else
					i := i + 1
				end
			end
		end

	is_subset_of (set: EL_SET [CHAR]; area: SPECIAL [CHAR]; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if set of characters in `area' between `start_index' to `end_index'
		-- is a subset of `set'
		local
			i: INTEGER
		do
			from Result := True; i := start_index until i > end_index or not Result loop
				if set.has (area [i]) then
					i := i + 1
				else
					Result := False
				end
			end
		end

	is_alpha_numeric_area (area: SPECIAL [CHAR]; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if set of characters in `area' between `start_index' to `end_index'
		-- is a subset of `set'
		local
			i: INTEGER
		do
			from Result := True; i := start_index until i > end_index or not Result loop
				if is_i_th_alpha_numeric (area, i) then
					i := i + 1
				else
					Result := False
				end
			end
		end

	is_ascii_area (area: SPECIAL [CHAR]; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if all characters in `area' are in the ASCII character set range: 0 .. 127
		require
			valid_start_index: start_index < area.count
			valid_end_index: end_index < area.count
		do
			Result := leading_ascii_count (area, start_index, end_index) = end_index - start_index + 1
		end

	is_ascii_alpha (c: CHAR): BOOLEAN
		do
			inspect to_character_8 (c)
				when 'a' .. 'z', 'A' .. 'Z' then
					Result := True
			else
			end
		end

	is_c_identifier_area (area: SPECIAL [CHAR]; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if set of characters in `area' between `start_index' to `end_index'
		-- is a subset of `set'
		local
			i: INTEGER
		do
			Result := True
			from i := start_index until i > end_index or not Result loop
				if is_c_identifier (area [i], i = start_index) then
					i := i + 1
				else
					Result := False
				end
			end
		end

	is_eiffel_identifier_area (area: SPECIAL [CHAR]; start_index, end_index: INTEGER; case_code: NATURAL_8): BOOLEAN
		-- `True' if set of characters in `area' between `start_index' to `end_index'
		-- is a subset of `set'
		require
			valid_case: is_valid_case (case_code)
		local
			i: INTEGER
		do
			Result := True
			from i := start_index until i > end_index or not Result loop
				if is_valid_eiffel_case (area [i], case_code, i = start_index) then
					i := i + 1
				else
					Result := False
				end
			end
		end

	is_left_bracket (c: CHAR): BOOLEAN
		do
			inspect right_bracket_offset (c)
				when 1, 2 then
					Result := True
			else
			end
		end

	same_caseless_sub_array (
		area_1, area_2: SPECIAL [CHAR]; offset_1, offset_2, comparison_count: INTEGER
	): BOOLEAN
		require
			valid_offset_1: area_1.valid_index (offset_1 + comparison_count - 1)
			valid_offset_2: area_2.valid_index (offset_2 + comparison_count - 1)
		local
			i: INTEGER
		do
			Result := True
			from i := 0 until not Result or i = comparison_count loop
				Result := same_caseless_character (area_1 [offset_1 + i], area_2 [offset_2 + i])
				i := i + 1
			end
		end

feature -- Measurement

	leading_ascii_count (area: SPECIAL [CHAR]; start_index, end_index: INTEGER): INTEGER
		require
			valid_start_index: start_index < area.count
			valid_end_index: end_index < area.count
		local
			i: INTEGER
		do
			from i := start_index until i > end_index loop
				inspect i_th_code (area, i)
					when 0 .. 0x7F then
						Result := Result + 1; i := i + 1
				else
					i := end_index + 1 -- break
				end
			end
		end

	right_bracket_offset (c: CHAR): INTEGER
		-- code offset to right bracket if `c' is a left bracket in ASCII range
		-- or else zero
		deferred
		end

feature {NONE} -- Deferred

	is_c_identifier (c: CHAR; is_first: BOOLEAN): BOOLEAN
		-- `True' if `c' is valid character in C language identifier
		-- where `is_first' indicates if `c' is first character in identifer
		deferred
		end

	is_valid_eiffel_case (c: CHAR; case_code: NATURAL; first_i: BOOLEAN): BOOLEAN
		deferred
		end

	is_i_th_alpha_numeric (area: SPECIAL [CHAR]; i: INTEGER): BOOLEAN
		deferred
		end

	i_th_code (area: SPECIAL [CHAR]; i: INTEGER): INTEGER
		deferred
		end

	shifted_character (c: CHAR; offset: INTEGER): CHAR
		deferred
		end

	same_caseless_character (a, b: CHAR): BOOLEAN
		deferred
		end

	to_character_8 (c: CHAR): CHARACTER_8
		deferred
		end

end