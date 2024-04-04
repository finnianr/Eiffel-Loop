note
	description: "Set of characters permissible in first letter of identifier"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 9:25:27 GMT (Thursday 4th April 2024)"
	revision: "1"

class
	EL_EIFFEL_FIRST_LETTER_CHARACTER_SET

inherit
	EL_SET [CHARACTER_8]

feature -- Status query

	has (c: CHARACTER_8): BOOLEAN
		do
			inspect c
				when 'A' .. 'Z', 'a' .. 'z' then
					Result := True
			else
				Result := False
			end
		end

end