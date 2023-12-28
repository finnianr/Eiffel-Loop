note
	description: "expanded class of character routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-28 10:14:21 GMT (Thursday 28th December 2023)"
	revision: "28"

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
			i: INTEGER; non_ascii: BOOLEAN
		do
			from i := start_index until non_ascii or else i > end_index loop
				inspect character_code (area, i) |>> 7
					when 0 then
						Result := Result + 1
				else
					non_ascii := True
				end
				i := i + 1
			end
		end

	right_bracket_offset (c: G): INTEGER
		-- code offset to right bracket if `c' is a left bracket in ASCII range
		-- or else zero
		deferred
		end

feature {NONE} -- Implementation

	character_code (area: SPECIAL [G]; i: INTEGER): NATURAL
		deferred
		end

	same_caseless_character (a, b: G): BOOLEAN
		deferred
		end
end