note
	description: "expanded class of character routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-25 12:14:11 GMT (Thursday 25th July 2024)"
	revision: "34"

deferred class
	EL_CHARACTER_ROUTINES [G -> COMPARABLE]

inherit
	EL_BIT_COUNTABLE

feature -- Access

	right_bracket (left_bracket: G): G
		require
			is_left: is_left_bracket (left_bracket)
		deferred
		end

feature -- Status query

	has_member (set: EL_SET [G]; area: SPECIAL [G]; start_index, end_index: INTEGER): BOOLEAN
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

	is_subset_of (set: EL_SET [G]; area: SPECIAL [G]; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if set of characters in `area' between `start_index' to `end_index'
		-- is a subset of `set'
		local
			i: INTEGER
		do
			from Result := True; i := start_index until not Result or i > end_index loop
				if set.has (area [i]) then
					i := i + 1
				else
					Result := False
				end
			end
		end

	is_ascii_area (area: SPECIAL [G]; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if all characters in `area' are in the ASCII character set range: 0 .. 127
		require
			valid_start_index: start_index < area.count
			valid_end_index: end_index < area.count
		do
			Result := leading_ascii_count (area, start_index, end_index) = end_index - start_index + 1
		end

	is_left_bracket (c: G): BOOLEAN
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
		area_1, area_2: SPECIAL [G]; offset_1, offset_2, comparison_count: INTEGER
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

	leading_ascii_count (area: SPECIAL [G]; start_index, end_index: INTEGER): INTEGER
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

	right_bracket_offset (c: G): INTEGER
		-- code offset to right bracket if `c' is a left bracket in ASCII range
		-- or else zero
		deferred
		end

feature {NONE} -- Implementation

	i_th_code (area: SPECIAL [G]; i: INTEGER): INTEGER
		deferred
		end

	same_caseless_character (a, b: G): BOOLEAN
		deferred
		end
end