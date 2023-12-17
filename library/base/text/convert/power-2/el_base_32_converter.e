note
	description: "Convert base 32 numeric strings to [$source NUMERIC] types"
	notes: "[
		Base 32 strings use the character ranges `0 .. 9, A .. V, a .. v' to represent 5 bit numbers 0 to 31.

		The strings '0Y' and '0y' are interpreted as a prefix for base 32 numbers in the same way
		as '0x' '0X' indicate a hexadecimal number
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-17 9:47:17 GMT (Sunday 17th December 2023)"
	revision: "9"

expanded class
	EL_BASE_32_CONVERTER

inherit
	EL_BASE_POWER_2_CONVERTER

feature -- Status query

	is_leading_digit (c: CHARACTER; index: INTEGER): BOOLEAN
		do
			inspect c
				when '0' then
					Result := True
				when 'y', 'Y' then
					Result := index = 2
			else end
		end

feature {NONE} -- Implementation

	is_valid_digit (c: CHARACTER; index: INTEGER): BOOLEAN
		do
			inspect c
				when '0' .. '9', 'A' .. 'V', 'a' .. 'v' then
					Result := True
				when  'y', 'Y' then
					Result := index = 2
			else end
		end

feature {NONE} -- Constants

	Bit_count: INTEGER = 5

end