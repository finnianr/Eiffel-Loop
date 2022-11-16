note
	description: "File persistent buildable from pyxis"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_FILE_PERSISTENT_BUILDABLE_FROM_PYXIS

inherit
	EL_FILE_PERSISTENT_BUILDABLE_FROM_NODE_SCAN
		redefine
			root_element_name, root_node_name
		end

	EL_PYXIS_PARSE_EVENT_TYPE

	EL_MODULE_PYXIS

feature -- Access

	root_element_name, root_node_name: STRING
			--
		do
			Result := Pyxis.root_element_name (template)
		end
end