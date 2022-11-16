note
	description: "Registry iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_REGISTRY_ITERATION_CURSOR [G]

inherit
	ITERATION_CURSOR [G]

feature {NONE} -- Initialization

	make (reg_path: DIR_PATH)
		do
			create registry
			registry_node := registry.open_key_with_access (reg_path, {WEL_REGISTRY_ACCESS_MODE}.Key_read)
			count := internal_count
			cursor_index := 1
		end

feature -- Access

	cursor_index: INTEGER

feature -- Status report	

	after: BOOLEAN
			--
		do
			Result := cursor_index > count
		end

feature -- Cursor movement

	forth
			--
		do
			cursor_index := cursor_index + 1
		end

feature {NONE} -- Implementation

	internal_count: INTEGER
		deferred
		end

	count: INTEGER

	registry: WEL_REGISTRY

	registry_node: POINTER

end