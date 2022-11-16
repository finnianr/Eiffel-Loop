note
	description: "C API routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_C_API_ROUTINES

feature -- Status query

	is_attached (a_pointer: POINTER): BOOLEAN
		do
			Result := not a_pointer.is_default_pointer
		end

end