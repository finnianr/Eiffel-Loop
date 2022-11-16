note
	description: "Registry raw data iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

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