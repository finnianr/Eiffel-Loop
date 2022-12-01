note
	description: "Conversion of hexadecimal numeric strings to numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-01 17:08:47 GMT (Thursday 1st December 2022)"
	revision: "5"

class
	EL_HEXADECIMAL_STRING_CONVERSION

inherit
	EL_POWER_2_BASE_NUMERIC_STRING_CONVERSION

feature -- Access

	natural_digit_count (code: NATURAL): INTEGER
		local
			mask: NATURAL
		do
			Result := 8
			mask := 0xF
			mask := mask |<< (32 - 4)
			from until mask = 0 or else (code & mask).to_boolean loop
				mask := mask |>> 4
				Result := Result - 1
			end
		end

feature -- Status query

	is_leading_digit (str: READABLE_STRING_GENERAL; index: INTEGER): BOOLEAN
		do
			inspect str.item (index)
				when '0', 'x', 'X' then
					Result := True
			else end
		end

feature {NONE} -- Implementation

	is_valid_digit (str: READABLE_STRING_GENERAL; index: INTEGER): BOOLEAN
		do
			inspect str [index]
				when 'x', 'X', '0' .. '9', 'A' .. 'F', 'a' .. 'f' then
					Result := True
			else end
		end

feature {NONE} -- Constants

	Bit_count: INTEGER = 4

end