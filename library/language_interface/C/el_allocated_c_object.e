note
	description: "C struct wrapper with memory allocated for it in `MANAGED_POINTER' attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "2"

class
	EL_ALLOCATED_C_OBJECT

inherit
	EL_C_OBJECT

feature {NONE} -- Initialization

	make_with_size (size: INTEGER)
			--
		do
			create memory.make (size)
			make_from_pointer (memory.item)
		end

feature {NONE} -- Implementation

	memory: MANAGED_POINTER
		-- allocated memory
end
