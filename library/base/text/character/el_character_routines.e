note
	description: "expanded class of character routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 9:31:30 GMT (Monday 7th August 2023)"
	revision: "24"

deferred class
	EL_CHARACTER_ROUTINES [G -> COMPARABLE]

inherit
	EL_BIT_COUNTABLE

feature -- Status query

	is_ascii_area (area: SPECIAL [G]; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if all characters in `area' are in the ASCII character set range: 0 .. 127
		require
			valid_start_index: start_index < area.count
			valid_end_index: end_index < area.count
		local
			i: INTEGER
		do
			Result := True
			from i := start_index until not Result or else i > end_index loop
				if area [i] > max_ascii_character then
					Result := False
				else
					i := i + 1
				end
			end
		end

	is_valid_eiffel_case (c: CHARACTER_8; case_code: NATURAL; first_i: BOOLEAN): BOOLEAN
		do
			inspect c
				when 'a' .. 'z' then
					if (case_code & {EL_CASE}.Title).to_boolean and then first_i then
						Result := False
					else
						Result := (case_code & {EL_CASE}.lower).to_boolean
					end

				when 'A' .. 'Z' then
					if (case_code & {EL_CASE}.Title).to_boolean and then first_i then
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

feature {NONE} -- Implementation

	max_ascii_character: G
		deferred
		end

	same_caseless_character (a, b: G): BOOLEAN
		deferred
		end
end