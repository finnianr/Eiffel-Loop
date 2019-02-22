note
	description: "Reflected reference object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-22 14:29:50 GMT (Friday 22nd February 2019)"
	revision: "1"

class
	EL_REFLECTED_REFERENCE_OBJECT

inherit
	REFLECTED_REFERENCE_OBJECT

create
	make

feature -- Status query

	all_references_attached: BOOLEAN
		-- `True' if all reference fields are initialized
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until not Result or i > field_count loop
				if field_type (i) = Reference_type then
					Result := Result and attached reference_field (i)
				end
				i := i + 1
			end
		end
end
