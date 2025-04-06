note
	description: "Base class for ${EL_CHARACTER_8_ROUTINES} and ${EL_CHARACTER_32_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-06 17:40:54 GMT (Sunday 6th April 2025)"
	revision: "37"

deferred class
	EL_CHARACTER_X_ROUTINES [CHAR -> COMPARABLE]

inherit
	EL_BIT_COUNTABLE

feature -- Access

	right_bracket (left_bracket: CHAR): CHAR
		require
			is_left: is_left_bracket (left_bracket)
		deferred
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

	is_left_bracket (c: CHAR): BOOLEAN
		do
			inspect right_bracket_offset (c)
				when 1, 2 then
					Result := True
			else
			end
		end

	is_valid_eiffel_case (c: CHARACTER_8; case_code: NATURAL; first_i: BOOLEAN): BOOLEAN
		do
			inspect c
				when 'a' .. 'z' then
					if (case_code & {EL_CASE}.Proper).to_boolean and then first_i then
						Result := False
					else
						Result := (case_code & {EL_CASE}.lower).to_boolean
					end

				when 'A' .. 'Z' then
					if (case_code & {EL_CASE}.Proper).to_boolean and then first_i then
						Result := True
					else
						Result := (case_code & {EL_CASE}.upper).to_boolean
					end

				when '0' .. '9', '_' then
					Result := not first_i
			else
				Result := False
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

	is_i_th_alpha_numeric (area: SPECIAL [CHAR]; i: INTEGER): BOOLEAN
		deferred
		end

	i_th_code (area: SPECIAL [CHAR]; i: INTEGER): INTEGER
		deferred
		end

	same_caseless_character (a, b: CHAR): BOOLEAN
		deferred
		end

	to_character_8 (c: CHAR): CHARACTER_8
		deferred
		end

end