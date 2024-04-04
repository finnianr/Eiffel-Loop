note
	description: "Set of characters permissible in an Eiffel identifier"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 9:31:34 GMT (Thursday 4th April 2024)"
	revision: "1"

class
	EL_EIFFEL_IDENTIFIER_CHARACTER_SET

inherit
	EL_EIFFEL_FIRST_LETTER_CHARACTER_SET
		redefine
			has
		end

feature -- Status query

	has (c: CHARACTER_8): BOOLEAN
		do
			inspect c
				when '0' .. '9', '_' then
					Result := True
			else
				Result := Precursor (c)
			end
		end

end