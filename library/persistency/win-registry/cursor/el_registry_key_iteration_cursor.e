note
	description: "Registry key iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
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