note
	description: "Extensions to ISE class ${CHARACTER_PROPERTY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:28:17 GMT (Tuesday 20th August 2024)"
	revision: "4"

class
	EL_UNICODE_PROPERTY

inherit
	CHARACTER_PROPERTY

create
	make

feature -- Status query

	same_caseless (a, b: CHARACTER_32): BOOLEAN
		do
			if a = b then
				Result := True
			else
				Result := to_lower (a) = to_lower (b)
			end
		end
end