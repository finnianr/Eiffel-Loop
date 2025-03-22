note
	description: "[
		Hints for reflective classes as to how fields should be mapped to XML attributes/elements
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-21 13:28:26 GMT (Friday 21st March 2025)"
	revision: "4"

deferred class
	EL_NODE_HINTS

inherit
	EL_REFLECTIVE_I

feature {NONE} -- Constants

	Empty_set: STRING = ""
		-- rename `element_node_fields' as this to exclude all

end