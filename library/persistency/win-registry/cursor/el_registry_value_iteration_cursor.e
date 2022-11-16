note
	description: "Registry value iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_REGISTRY_VALUE_ITERATION_CURSOR [G]

inherit
	EL_REGISTRY_ITERATION_CURSOR [G]

feature {NONE} -- Implementation

	key_value (name: STRING_32): WEL_REGISTRY_KEY_VALUE
		do
			Result := registry.key_value (registry_node, name)
		end

	item_name: STRING_32
		do
			Result := registry.enumerate_value (registry_node, cursor_index - 1)
		end

	internal_count: INTEGER
		do
			Result := registry.number_of_values (registry_node)
		end

end