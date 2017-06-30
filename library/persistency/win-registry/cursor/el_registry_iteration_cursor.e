note
	description: "Summary description for {EL_REGISTRY_ITERATION_CURSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-22 15:03:30 GMT (Thursday 22nd June 2017)"
	revision: "2"

deferred class
	EL_REGISTRY_ITERATION_CURSOR [G]

inherit
	ITERATION_CURSOR [G]

feature {NONE} -- Initialization

	make (reg_path: EL_DIR_PATH)
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
