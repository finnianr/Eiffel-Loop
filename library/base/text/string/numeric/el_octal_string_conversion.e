note
	description: "Conversion of octal numeric strings to numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-01 16:58:52 GMT (Thursday 1st December 2022)"
	revision: "4"

class
	EL_OCTAL_STRING_CONVERSION

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
				when '0' .. '7' then
					Result := True
			else end
		end

feature {NONE} -- Constants

	Bit_count: INTEGER = 3

end