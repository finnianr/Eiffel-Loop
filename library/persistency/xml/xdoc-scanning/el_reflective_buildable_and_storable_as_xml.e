note
	description: "[
		Object that can both 
			
			1. reflectively build itself from XML
			2. reflectively store itself as XML
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-06 16:01:49 GMT (Thursday 6th June 2019)"
	revision: "1"

deferred class
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML

inherit
	EL_BUILDABLE_FROM_XML
		undefine
			is_equal, make_default, new_building_actions
		end

	EL_REFLECTIVE_BUILDABLE_FROM_NODE_SCAN
		rename
			element_node_type as	Attribute_node,
			xml_names as export_default
		end

feature {NONE} -- Implementation

	root_node_name: STRING
			--
		do
			Result := Naming.class_as_lower_snake (Current, 0, 0)
		end

end
