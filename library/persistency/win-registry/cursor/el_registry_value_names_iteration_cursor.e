note
	description: "Summary description for {EL_REGISTRY_VALUE_ITERATION_CURSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-30 17:37:53 GMT (Wednesday 30th March 2016)"
	revision: "1"

class
	EL_REGISTRY_VALUE_NAMES_ITERATION_CURSOR

inherit
	EL_REGISTRY_ITERATION_CURSOR [ZSTRING]
		rename
			item as name
		end

create
	make

feature -- Access

	name: ZSTRING
			-- Item at current cursor position.
		do
			Result := registry.enumerate_value (registry_node, cursor_index - 1)
		end

	internal_count: INTEGER
		do
			Result := registry.number_of_values (registry_node)
		end

end