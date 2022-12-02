note
	description: "Conversion of hexadecimal numeric strings to numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-02 14:22:59 GMT (Friday 2nd December 2022)"
	revision: "7"

expanded class
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

	is_leading_digit (c: CHARACTER; index: INTEGER): BOOLEAN
		do
			inspect c
				when '0' then
					Result := True
				when 'x', 'X' then
					Result := index = 2
			else end
		end

feature {NONE} -- Implementation

	is_valid_digit (c: CHARACTER; index: INTEGER): BOOLEAN
		do
			inspect c
				when '0' .. '9', 'A' .. 'F', 'a' .. 'f' then
					Result := True
				when  'x', 'X' then
					Result := index = 2
			else end
		end

feature {NONE} -- Constants

	Bit_count: INTEGER = 4

end