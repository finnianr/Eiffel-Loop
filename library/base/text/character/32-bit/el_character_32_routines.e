note
	description: "Expanded class of ${CHARACTER_32} routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-06 17:35:04 GMT (Sunday 6th April 2025)"
	revision: "21"

expanded class
	EL_CHARACTER_32_ROUTINES

inherit
	EL_CHARACTER_X_ROUTINES [CHARACTER_32]

	EL_32_BIT_IMPLEMENTATION

	EL_EXPANDED_ROUTINES

	EL_UNICODE_PROPERTY

	EL_SHARED_UTF_8_SEQUENCE

feature -- Access

	right_bracket (left_bracket: CHARACTER_32): CHARACTER_32
		do
			Result := left_bracket + right_bracket_offset (left_bracket).to_natural_32
		end

feature -- Basic operations

	write_utf_8 (uc: CHARACTER_32; writeable: EL_WRITABLE)
		local
			sequence: like Utf_8_sequence
		do
			sequence := Utf_8_sequence
			sequence.set (uc)
			sequence.write (writeable)
		end

feature -- Measurement

	right_bracket_offset (c: CHARACTER_32): INTEGER
		-- code offset to right bracket if `c' is a left bracket in ASCII range
		-- or else zero
		do
			inspect c
				when '(' then
					Result := 1
				when '{', '[', '<'  then
					Result := 2
			else
			end
		end

feature -- Status query

	is_c_identifier (c: CHARACTER_32; is_first: BOOLEAN): BOOLEAN
		-- `True' if `c' is valid character in C language identifier
		-- where `is_first' indicates if `c' is first character in identifer
		do
			inspect c
				when 'a' .. 'z', 'A' .. 'Z' then
					Result := True

				when '0' .. '9', '_' then
					Result := not is_first
			else
			end
		end

feature -- Area query

	is_i_th_eiffel_identifier (area: SPECIAL [CHARACTER_32]; i: INTEGER; case_code: NATURAL; first_i: BOOLEAN): BOOLEAN
		local
			uc: CHARACTER_32
		do
			uc := area [i]
			if uc.is_character_8 then
				Result := is_valid_eiffel_case (uc.to_character_8, case_code, first_i)
			end
		end

feature {NONE} -- Implementation

	i_th_code (area: SPECIAL [CHARACTER_32]; i: INTEGER): INTEGER
		do
			Result := area [i].code
		end

	is_i_th_alpha_numeric (area: SPECIAL [CHARACTER_32]; i: INTEGER): BOOLEAN
		do
			Result := area [i].is_alpha_numeric
		end

	same_caseless_character (a, b: CHARACTER_32): BOOLEAN
		do
			Result := to_lower (a) = to_lower (b)
		end

	to_character_8 (c: CHARACTER_32): CHARACTER_8
		do
			Result := c.to_character_8
		end

end