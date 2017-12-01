note
	description: "Summary description for {EL_HEXADECIMAL_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-24 13:27:51 GMT (Friday 24th November 2017)"
	revision: "1"

class
	EL_HEXADECIMAL_ROUTINES [S -> READABLE_STRING_GENERAL]

feature -- Access

	hexadecimal_to_integer (str: S): INTEGER
			--
		do
			Result := hexadecimal_to_natural_64 (str).to_integer_32
		end

	hexadecimal_to_natural_64 (str: S): NATURAL_64
			--
		local
			i, count, bitshift: INTEGER; code: NATURAL
			nibble: NATURAL_64; found: BOOLEAN
		do
			count := str.count
			-- Skip 0x00
			from i := 1 until found or i > count loop
				inspect str.item (i)
					when '0', 'x', 'X' then
						i := i + 1
				else
					found := True
				end
			end
			from until i > count loop
				code := str.item (i).natural_32_code
				if code <= Code_nine then
					nibble := code - Code_zero
				elseif code >= Code_a_lower then
					nibble := code - Code_a_lower + 10

				elseif code >= Code_a_upper then
					nibble := code - Code_a_upper + 10
				else
					nibble := 0
				end
				bitshift := (count - i) * 4
				Result := Result | (nibble |<< bitshift)
				i := i + 1
			end
		end

feature {NONE} -- Constants

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

	Code_zero: NATURAL
		once
			Result := ('0').natural_32_code
		end

end
