note
	description: "Summary description for {EL_REGISTRY_INTEGER_VALUE_ITERATION_CURSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-30 17:37:27 GMT (Wednesday 30th March 2016)"
	revision: "4"

class
	EL_REGISTRY_INTEGER_VALUE_ITERATION_CURSOR

inherit
	EL_REGISTRY_VALUE_ITERATION_CURSOR [TUPLE [name: ZSTRING; value: INTEGER]]

create
	make

feature -- Access

	item: TUPLE [name: ZSTRING; value: INTEGER]
			-- Item at current cursor position.
		do
			create Result
			Result.name := item_name
			Result.value := key_value (Result.name).dword_value
		end
end
