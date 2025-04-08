note
	description: "Expanded class of ${CHARACTER_8} routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 10:28:57 GMT (Tuesday 8th April 2025)"
	revision: "36"

expanded class
	EL_CHARACTER_8_ROUTINES

inherit
	EL_CHARACTER_X_ROUTINES [CHARACTER_8]

	EL_8_BIT_IMPLEMENTATION

	EL_EXPANDED_ROUTINES

	EL_LATIN_1

feature -- Measurement

	right_bracket_offset (c: CHARACTER_8): INTEGER
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

	is_a_to_z_caseless (c: CHARACTER_8): BOOLEAN
		do
			inspect c
				when 'a' .. 'z', 'A' .. 'Z' then
					Result := True
			else
			end
		end

	is_a_to_z_lower (c: CHARACTER_8): BOOLEAN
		do
			inspect c
				when 'a' .. 'z' then
					Result := True
			else
			end
		end

	is_a_to_z_upper (c: CHARACTER_8): BOOLEAN
		do
			inspect c
				when 'A' .. 'Z' then
					Result := True
			else
			end
		end

	is_c_identifier (c: CHARACTER_8; is_first: BOOLEAN): BOOLEAN
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

	is_latin1_alpha (c: CHARACTER_8): BOOLEAN
			--
		do
			Result := is_latin1_lower (c) or else is_latin1_upper (c) or else c.code.to_natural_32 = Sharp_s
						or else c.code.to_natural_32 = Y_dieresis
		end

	is_latin1_lower (c: CHARACTER_8): BOOLEAN
			--
		local
			code: NATURAL
		do
			code := c.code.to_natural_32
			inspect code
				when Multiply_sign then

			else
				inspect code
					when Lcase_a .. Lcase_z then
						Result := True

					when Lcase_a_grave .. Lcase_thorn then
						Result := True

				else
				end
			end
		end

	is_latin1_upper (c: CHARACTER_8): BOOLEAN
			--
		local
			code: NATURAL
		do
			code := c.code.to_natural_32
			inspect code
				when Division_sign then

			else
				inspect code
					when Ucase_A .. Ucase_Z then
						Result := True

					when Ucase_A_GRAVE .. Ucase_THORN then
						Result := True

				else
				end
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

feature -- Conversion

	digit_to_integer (c: CHARACTER_8): INTEGER
		require
			is_digit: '0' <= c and c <= '9'
		do
			Result := c.code - ('0').code
		end

	hex_digit_to_decimal (c: CHARACTER_8): INTEGER
		-- Hex digit to decimal (base 10)
		do
			inspect c
				when 'a' .. 'f', 'A' .. 'F'  then
					Result := c.code - ('a').code + 10
				when '0' .. '9' then
					Result := c.code - ('0').code
			else
			end
		end

	latin1_lower_case (c: CHARACTER_8): CHARACTER_8
			--
		local
			code: NATURAL
		do
			code := c.code.to_natural_32
			inspect code
				when Ucase_A .. Ucase_Z then
					Result := (code - Ucase_A + Lcase_a).to_character_8

				when Ucase_A_GRAVE .. Ucase_THORN then
					if code = Multiply_sign then
						Result := c
					else
						Result := (code - Ucase_A_GRAVE + Lcase_a_grave).to_character_8
					end

			else
				Result := c
			end
		end

	latin1_upper_case (c: CHARACTER_8): CHARACTER_8
			--
		local
			code: NATURAL
		do
			code := c.code.to_natural_32
			inspect code
				when Lcase_a .. Lcase_z then
					Result := (code - Lcase_a + Ucase_A).to_character_8

				when Lcase_a_grave .. Lcase_thorn then
					if code = Division_sign then
						Result := c
					else
						Result := (code - Lcase_a_grave + Ucase_A_GRAVE).to_character_8
					end

			else
				Result := c
			end
		end

feature {NONE} -- Implementation

	is_i_th_alpha_numeric (area: SPECIAL [CHARACTER_8]; i: INTEGER): BOOLEAN
		do
			Result := area [i].is_alpha_numeric
		end

	i_th_code (area: SPECIAL [CHARACTER_8]; i: INTEGER): INTEGER
		do
			Result := area [i].code
		end

	shifted_character (c: CHARACTER_8; offset: INTEGER): CHARACTER_8
		do
			Result := c + offset
		end

	same_caseless_character (a, b: CHARACTER_8): BOOLEAN
		do
			Result := a.as_lower = b.as_lower
		end

	to_character_8 (c: CHARACTER_8): CHARACTER_8
		do
			Result := c
		end

end