note
	description: "Summary description for {EL_REGISTRY_RAW_DATA_ITERATION_CURSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

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