note
	description: "Registry integer value iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

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