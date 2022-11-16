note
	description: "[
		Object that can both 
			
			1. reflectively build itself from XML
			2. reflectively store itself as XML
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "25"

deferred class
	EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML

inherit
	EL_FILE_PERSISTENT
		undefine
			make_from_file
		end

	EL_BUILDABLE_FROM_XML
		rename
			xml_name_space as xmlns
		undefine
			is_equal, new_building_actions, make_from_file
		redefine
			make_default
		end

	EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN
		rename
			element_node_fields as Empty_set,
			xml_name_space as xmlns
		export
			{NONE} all
		redefine
			make_from_file, make_default, Transient_fields
		end

	EL_MODULE_NAMING; EL_MODULE_XML

	EL_FILE_OPEN_ROUTINES

feature {NONE} -- Initialization

	make_from_file (a_file_path: like file_path)
			--
		do
			file_path := a_file_path
			Precursor {EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN} (a_file_path)
		end

	make_default
		do
			if not attached file_path then
				create file_path
			end
			Precursor {EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN}
		end

feature {NONE} -- Implementation

	put_xml_document (xml_out: EL_OUTPUT_MEDIUM)
		do
			xml_out.put_bom
			xml_out.put_string (XML.header (1.0, once "UTF-8"))
			xml_out.put_new_line
			put_xml_element (xml_out, root_node_name, 0)
		end

	store_as (a_file_path: FILE_PATH)
		do
			if attached open (a_file_path, Write) as xml_out then
				put_xml_document (xml_out)
				xml_out.close
			end
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

	root_node_name: STRING
			--
		do
			Result := Naming.class_as_snake_lower (Current, 0, 0)
		end

feature {NONE} -- Constants

	Transient_fields: STRING
		once
			Result := "file_path, last_store_ok"
		end

end