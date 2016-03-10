note
	description: "Summary description for {EL_REGISTRY_RAW_DATA_VALUES_ITERABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EL_REGISTRY_RAW_DATA_VALUES_ITERABLE

inherit
	EL_REGISTRY_ITERABLE [TUPLE [name: EL_ASTRING; data: MANAGED_POINTER]]

create
	make

feature -- Access: cursor

	new_cursor: EL_REGISTRY_RAW_DATA_ITERATION_CURSOR
		do
			create Result.make (reg_path)
		end
end
