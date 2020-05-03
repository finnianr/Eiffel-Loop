note
	description: "Conversion of hexadecimal numeric strings to numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-03 8:39:53 GMT (Sunday 3rd May 2020)"
	revision: "3"

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

feature -- Conversion

	to_decimal (code: NATURAL): NATURAL
		do
			if code <= Code_nine then
				Result := code - Code_zero

			elseif code >= Code_a_lower then
				Result := code - Code_a_lower + 10

			elseif code >= Code_a_upper then
				Result := code - Code_a_upper + 10
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

	Code_a_lower: NATURAL
		once
			Result := ('a').natural_32_code
		end

	Code_a_upper: NATURAL
		once
			Result := ('A').natural_32_code
		end

	Code_nine: NATURAL
		once
			Result := ('9').natural_32_code
		end

end
