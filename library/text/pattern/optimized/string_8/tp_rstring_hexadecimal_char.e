note
	description: "[$source TP_HEXADECIMAL_CHAR] optimized for strings conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-08 10:08:43 GMT (Wednesday 8th February 2023)"
	revision: "4"

class
	TP_RSTRING_HEXADECIMAL_CHAR

inherit
	TP_HEXADECIMAL_CHAR
		redefine
			i_th_matches
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		do
			inspect text [i]
				when '0' .. '9', 'a' .. 'f', 'A' .. 'F' then
					Result := True
			else
			end
		end

end