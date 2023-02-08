note
	description: "Extensions to ISE class [$source CHARACTER_PROPERTY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-08 12:17:25 GMT (Wednesday 8th February 2023)"
	revision: "1"

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

			elseif is_lower (a) then
				Result := a = b.as_lower

			elseif is_upper (a) then
				Result := a = b.as_upper

			end
		end
end