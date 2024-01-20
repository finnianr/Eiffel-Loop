note
	description: "Set of characters permissible in type name (which may have generic parameters)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-19 9:49:25 GMT (Friday 19th January 2024)"
	revision: "1"

class
	EL_EIFFEL_TYPE_NAME_CHARACTER_SET

inherit
	EL_SET [CHARACTER_8]

feature -- Status query

	has (c: CHARACTER_8): BOOLEAN
		do
			inspect c
				when 'A' .. 'Z', '0' .. '9', '_', ' ', '[', ']' then
					Result := True
			else
				Result := False
			end
		end

end