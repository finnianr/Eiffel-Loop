note
	description: "Summary description for {EL_CHARACTER_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_CHARACTER_ROUTINES

inherit
	EL_LATIN_1

feature -- Status query

	is_latin1_lower (c: CHARACTER): BOOLEAN
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

	is_latin1_upper (c: CHARACTER): BOOLEAN
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

	is_latin1_alpha (c: CHARACTER): BOOLEAN
			--
		do
			Result := is_latin1_lower (c) or else is_latin1_upper (c) or else c.code.to_natural_32 = Sharp_s
						or else c.code.to_natural_32 = Y_dieresis
		end

feature -- Conversion

	hex_digit_to_decimal (c: CHARACTER): INTEGER
		do
			if c >= 'a' then
				Result := c.code - ('a').code + 10

			elseif c >= 'A' then
				Result := c.code - ('A').code + 10

			elseif c >= '0' then
				Result := c.code - ('0').code

			end
		end

	latin1_lower_case (c: CHARACTER): CHARACTER
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

	latin1_upper_case (c: CHARACTER): CHARACTER
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


end
