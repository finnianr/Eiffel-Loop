note
	description: "Summary description for {EL_REGISTRY_RAW_DATA_ITERATION_CURSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-30 17:37:32 GMT (Wednesday 30th March 2016)"
	revision: "5"

class
	EL_REGISTRY_RAW_DATA_ITERATION_CURSOR

inherit
	EL_REGISTRY_VALUE_ITERATION_CURSOR [TUPLE [name: ZSTRING; data: MANAGED_POINTER]]

create
	make

feature -- Access

	item: TUPLE [name: ZSTRING; data: MANAGED_POINTER]
			-- Item at current cursor position.
		do
			create Result
			Result.name := item_name
			Result.data := key_value (Result.name).data
		end
end