note
	description: "Convert octal numeric strings to ${NUMERIC} types"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "9"

expanded class
	EL_OCTAL_CONVERTER

inherit
	EL_BASE_POWER_2_CONVERTER

feature -- Status query

	is_leading_digit (c: CHARACTER; index: INTEGER): BOOLEAN
		do
			Result := c = '0'
		end

feature {NONE} -- Implementation

	is_valid_digit (c: CHARACTER; index: INTEGER): BOOLEAN
		do
			inspect c
				when '0' .. '7' then
					Result := True
			else end
		end

feature {NONE} -- Constants

	Bit_count: INTEGER = 3

end