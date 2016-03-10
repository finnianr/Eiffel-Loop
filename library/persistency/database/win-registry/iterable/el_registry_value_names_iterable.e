note
	description: "Summary description for {EL_ITERABLE_REGISTRY_VALUES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EL_REGISTRY_VALUE_NAMES_ITERABLE

inherit
	EL_REGISTRY_ITERABLE [EL_ASTRING]

create
	make

feature -- Access: cursor

	new_cursor: EL_REGISTRY_VALUE_NAMES_ITERATION_CURSOR
		do
			create Result.make (reg_path)
		end

end
