note
	description: "Reflected reference object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-10 10:32:05 GMT (Monday 10th May 2021)"
	revision: "2"

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
			i, count: INTEGER
		do
			Result := True; count := field_count
			from i := 1 until not Result or i > count loop
				if field_type (i) = Reference_type then
					Result := Result and attached reference_field (i)
				end
				i := i + 1
			end
		end
end