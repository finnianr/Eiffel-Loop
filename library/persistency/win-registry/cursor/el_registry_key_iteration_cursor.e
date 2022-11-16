note
	description: "Registry key iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

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