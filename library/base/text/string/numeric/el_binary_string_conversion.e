note
	description: "Conversion of binary numeric strings to numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-01 16:58:10 GMT (Thursday 1st December 2022)"
	revision: "4"

class
	EL_BINARY_STRING_CONVERSION

inherit
	EL_POWER_2_BASE_NUMERIC_STRING_CONVERSION

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