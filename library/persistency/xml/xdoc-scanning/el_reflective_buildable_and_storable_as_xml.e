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
	date: "2019-06-07 16:35:18 GMT (Friday 7th June 2019)"
	revision: "3"

deferred class
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML

inherit
	EL_BUILDABLE_FROM_XML
		rename
			xml_name_space as xmlns
		undefine
			is_equal, make_default, new_building_actions
		end

	EL_REFLECTIVE_BUILDABLE_FROM_NODE_SCAN
		rename
			element_node_type as	Attribute_node,
			xml_names as export_default,
			xml_name_space as xmlns
		export
			{NONE} all
		end

	EL_MODULE_XML
		undefine
			is_equal
		end

feature -- Basic operations

	store (file_path: EL_FILE_PATH)
		local
			xml_out: EL_PLAIN_TEXT_FILE
		do
			create xml_out.make_open_write (file_path)
			xml_out.put_bom
			xml_out.put_string (XML.header (1.0, once "UTF-8"))
			xml_out.put_new_line
			put_xml_element (xml_out, root_node_name, 0)
			xml_out.close
		end

feature {NONE} -- Implementation

	root_node_name: STRING
			--
		do
			Result := Naming.class_as_lower_snake (Current, 0, 0)
		end

end
