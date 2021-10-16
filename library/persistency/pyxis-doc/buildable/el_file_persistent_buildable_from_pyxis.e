note
	description: "File persistent buildable from pyxis"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-14 11:26:17 GMT (Thursday 14th October 2021)"
	revision: "6"

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