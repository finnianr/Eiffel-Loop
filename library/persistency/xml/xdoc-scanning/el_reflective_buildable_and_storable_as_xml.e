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
	date: "2019-06-12 10:58:29 GMT (Wednesday 12th June 2019)"
	revision: "5"

deferred class
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML

inherit
	EL_FILE_PERSISTENT
		undefine
			is_equal, make_from_file
		end

	EL_BUILDABLE_FROM_XML
		rename
			xml_name_space as xmlns
		undefine
			is_equal, make_default, new_building_actions, make_from_file
		end

	EL_REFLECTIVE_BUILDABLE_FROM_NODE_SCAN
		rename
			element_node_type as	Attribute_node,
			xml_names as export_default,
			xml_name_space as xmlns
		export
			{NONE} all
		redefine
			make_from_file, make_default, Except_fields
		end

	EL_MODULE_XML
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_from_file (a_file_path: like file_path)
			--
		do
			file_path := a_file_path
			Precursor {EL_REFLECTIVE_BUILDABLE_FROM_NODE_SCAN} (a_file_path)
		end

	make_default
		do
			register_default_values
			if not attached file_path then
				create file_path
			end
			Precursor {EL_REFLECTIVE_BUILDABLE_FROM_NODE_SCAN}
		end

feature {NONE} -- Implementation

	put_xml_document (xml_out: EL_OUTPUT_MEDIUM)
		do
			xml_out.put_bom
			xml_out.put_string (XML.header (1.0, once "UTF-8"))
			xml_out.put_new_line
			put_xml_element (xml_out, root_node_name, 0)
		end

	store_as (a_file_path: EL_FILE_PATH)
		local
			xml_out: EL_PLAIN_TEXT_FILE
		do
			create xml_out.make_open_write (a_file_path)
			put_xml_document (xml_out)
			xml_out.close
		end

	stored_successfully (a_file: like new_file): BOOLEAN
		local
			medium: EL_STRING_8_IO_MEDIUM
		do
			create medium.make (a_file.count)
			put_xml_document (medium)
			Result := medium.count = a_file.count
			medium.close
		end

	new_file (a_file_path: like file_path): EL_PLAIN_TEXT_FILE
		do
			create Result.make_with_name (a_file_path)
		end

	register_default_values
		-- Implement this as a once routine to register a default value for any attributes
		-- conforming to class `EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT'.
	 	-- For example:
		-- once
		--		Default_value_table.extend_from_array (<< create {like values}.make_default >>)
		--	end
		deferred
		end

	root_node_name: STRING
			--
		do
			Result := Naming.class_as_lower_snake (Current, 0, 0)
		end

feature {NONE} -- Constants

	Except_fields: STRING
		once
			Result := Precursor + ", file_path"
		end

end
