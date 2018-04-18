note
	description: "Conversion of binary numeric strings to numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-05 15:25:56 GMT (Thursday 5th April 2018)"
	revision: "2"

class
	EL_BINARY_STRING_CONVERSION

inherit
	EL_POWER_2_BASE_NUMERIC_STRING_CONVERSION

feature -- Conversion

	to_decimal (code: NATURAL): NATURAL
		do
			Result := code - Code_zero
		end

feature -- Status query

	is_leading_digit (str: READABLE_STRING_GENERAL; index: INTEGER): BOOLEAN
		do
			Result := str [index] = '0'
		end

feature {NONE} -- Implementation

	is_valid_digit (str: READABLE_STRING_GENERAL; index: INTEGER): BOOLEAN
		do
			inspect str [index]
				when '0' .. '1' then
					Result := True
			else end
		end

feature {NONE} -- Constants

	Bit_count: INTEGER = 1

end
