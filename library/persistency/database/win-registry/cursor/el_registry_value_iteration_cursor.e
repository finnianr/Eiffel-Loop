note
	description: "Summary description for {EL_REGISTRY_VALUE_ITERATION_CURSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "4"

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
