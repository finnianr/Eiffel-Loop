note
	description: "Summary description for {EL_REGISTRY_KEY_ITERATION_CURSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_REGISTRY_KEY_ITERATION_CURSOR

inherit
	EL_REGISTRY_ITERATION_CURSOR [WEL_REGISTRY_KEY]

create
	make

feature -- Access

	item: WEL_REGISTRY_KEY
			-- Item at current cursor position.
		do
			Result := registry.enumerate_key (registry_node, cursor_index - 1)
		end

	internal_count: INTEGER
		do
			Result := registry.number_of_subkeys (registry_node)
		end

end
