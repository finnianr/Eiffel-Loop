note
	description: "Summary description for {EL_REGISTRY_RAW_DATA_ITERATION_CURSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_REGISTRY_RAW_DATA_ITERATION_CURSOR

inherit
	EL_REGISTRY_VALUE_ITERATION_CURSOR [TUPLE [name: EL_ASTRING; data: MANAGED_POINTER]]

create
	make

feature -- Access

	item: TUPLE [name: EL_ASTRING; data: MANAGED_POINTER]
			-- Item at current cursor position.
		do
			create Result
			Result.name := item_name
			Result.data := key_value (Result.name).data
		end
end
