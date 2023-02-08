note
	description: "Match hexadecimal character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-08 10:08:28 GMT (Wednesday 8th February 2023)"
	revision: "4"

class
	TP_HEXADECIMAL_CHAR

inherit
	TP_CHARACTER_PROPERTY
		rename
			name_inserts as Empty_inserts
		end

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
			inspect text [i]
				when '0' .. '9', 'a' .. 'f', 'A' .. 'F' then
					Result := True
			else
			end
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "hexadecimal"
		end

end