note
	description: "Routines that define ${CHARACTER_8} sets"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-27 10:45:17 GMT (Sunday 27th April 2025)"
	revision: "1"

deferred class
	EL_CHARACTER_8_SETS

inherit
	EL_ROUTINES

	EL_LATIN_1
		export
			{NONE} all
		end

feature {NONE} -- Set queries

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

	not_a_to_z_caseless (c: CHARACTER): BOOLEAN
		do
			Result := not is_a_to_z_caseless (c)
		end

end