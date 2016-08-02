note
	description: "Summary description for {EL_REGISTRY_INTEGER_VALUES_ITERABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-30 17:37:19 GMT (Wednesday 30th March 2016)"
	revision: "1"

class
	EL_REGISTRY_INTEGER_VALUES_ITERABLE

inherit
	EL_REGISTRY_ITERABLE [TUPLE [name: ZSTRING; value: INTEGER]]

create
	make

feature -- Access: cursor

	new_cursor: EL_REGISTRY_INTEGER_VALUE_ITERATION_CURSOR
		do
			create Result.make (reg_path)
		end
end