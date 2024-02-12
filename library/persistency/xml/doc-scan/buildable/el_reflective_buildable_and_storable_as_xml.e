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
	date: "2024-02-05 10:39:32 GMT (Monday 5th February 2024)"
	revision: "31"

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
			make_from_file, make_default, new_transient_fields
		end

	EL_MODULE_XML

	EL_FILE_OPEN_ROUTINES

feature {NONE} -- Initialization

	make_from_file (a_file_path: FILE_PATH)
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

	put_xml_document (output: EL_OUTPUT_MEDIUM)
		local
			exporter: EL_XML_OBJECT_EXPORTER [like Current]
		do
			create exporter.make (Current)
			output.put_bom
			exporter.put_header (output)
			exporter.put_element (output, root_node_name, 0)
		end

	store_as (a_file_path: FILE_PATH)
		do
			if attached open (a_file_path, Write) as xml_out then
				xml_out.byte_order_mark.enable
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

	new_transient_fields: STRING
		do
			Result := Precursor + ", file_path, last_store_ok"
		end

end