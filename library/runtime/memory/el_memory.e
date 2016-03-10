note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-02-24 18:03:34 GMT (Monday 24th February 2014)"
	revision: "2"

class
	EL_MEMORY

inherit
	MEMORY

feature -- Status query

	is_attached (a_pointer: POINTER): BOOLEAN
		local
			null: POINTER
		do
			Result := a_pointer /= null
		end

end
