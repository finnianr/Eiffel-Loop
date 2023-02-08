note
	description: "[$source TP_HEXADECIMAL_CHAR] optimized for [$source ZSTRING] source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-08 10:09:01 GMT (Wednesday 8th February 2023)"
	revision: "4"

class
	TP_ZSTRING_HEXADECIMAL_CHAR

inherit
	TP_HEXADECIMAL_CHAR
		redefine
			i_th_matches
		end

	TP_OPTIMIZED_FOR_ZSTRING

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: ZSTRING): BOOLEAN
		do
			inspect text.item_8 (i)
				when '0' .. '9', 'a' .. 'f', 'A' .. 'F' then
					Result := True
			else
			end
		end

end
