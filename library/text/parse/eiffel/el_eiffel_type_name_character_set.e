note
	description: "Set of characters permissible in type name (which may have generic parameters)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-31 9:18:10 GMT (Sunday 31st March 2024)"
	revision: "2"

class
	EL_EIFFEL_TYPE_NAME_CHARACTER_SET

inherit
	EL_EIFFEL_CLASS_NAME_CHARACTER_SET
		redefine
			has
		end

feature -- Status query

	has (c: CHARACTER_8): BOOLEAN
		do
			inspect c
				when ' ', '[', ']' then
					Result := True
			else
				Result := Precursor (c)
			end
		end

end