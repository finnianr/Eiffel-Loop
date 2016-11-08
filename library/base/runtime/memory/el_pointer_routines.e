note
	description: "Summary description for {EL_POINTER_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-03 15:40:38 GMT (Monday 3rd October 2016)"
	revision: "1"

class
	EL_POINTER_ROUTINES

feature -- Status query

	is_attached (a_pointer: POINTER): BOOLEAN
		do
			Result := not a_pointer.is_default_pointer
		end

end
