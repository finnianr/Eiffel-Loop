note
	description: "${TP_HEXADECIMAL_DIGITS} optimized for ${ZSTRING} source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "6"

class
	TP_ZSTRING_HEXADECIMAL_DIGITS

inherit
	TP_HEXADECIMAL_DIGITS
		redefine
			i_th_is_digit
		end

create
	make

feature {NONE} -- Implementation

	i_th_is_digit (i: INTEGER; text: ZSTRING): BOOLEAN
		do
			inspect text.item_8 (i)
				when '0' .. '9', 'a' .. 'f', 'A' .. 'F' then
					Result := True
			else
			end
		end

end