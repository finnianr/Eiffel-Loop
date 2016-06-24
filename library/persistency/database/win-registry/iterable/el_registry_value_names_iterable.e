note
	description: "Summary description for {EL_ITERABLE_REGISTRY_VALUES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-30 17:37:49 GMT (Wednesday 30th March 2016)"
	revision: "5"

class
	EL_REGISTRY_VALUE_NAMES_ITERABLE

inherit
	EL_REGISTRY_ITERABLE [ZSTRING]

create
	make

feature -- Access: cursor

	new_cursor: EL_REGISTRY_VALUE_NAMES_ITERATION_CURSOR
		do
			create Result.make (reg_path)
		end

end
