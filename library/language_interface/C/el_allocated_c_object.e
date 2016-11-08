note
	description: "C struct wrapper with memory allocated for it in `MANAGED_POINTER' attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-04 7:57:44 GMT (Tuesday 4th October 2016)"
	revision: "1"

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
