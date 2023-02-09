note
	description: "[
		[$source TP_HEXADECIMAL_DIGITS] optimized for strings conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-09 16:19:28 GMT (Thursday 9th February 2023)"
	revision: "5"

class
	TP_RSTRING_HEXADECIMAL_DIGITS

inherit
	TP_HEXADECIMAL_DIGITS
		redefine
			i_th_is_digit
		end

create
	make

feature {NONE} -- Implementation

	i_th_is_digit (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		do
			inspect text [i]
				when '0' .. '9', 'a' .. 'f', 'A' .. 'F' then
					Result := True
			else
			end
		end

end