note
	description: "Binary builder factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-20 17:37:10 GMT (Sunday 20th December 2020)"
	revision: "2"

class
	BINARY_BUILDER_FACTORY

inherit
	BUILDER_FACTORY
		rename
			make as make_factory
		redefine
			new_matrix, new_serializeable, new_smil_presentation, new_web_form
		end

create
	make

feature {NONE} -- Initialization

	make (a_work_area_dir: EL_DIR_PATH)
		do
			work_area_dir := a_work_area_dir
			create smart_builder.make (Binary_encoded_event_source)
		end

feature -- Factory

	new_matrix (file_path: EL_FILE_PATH): MATRIX_CALCULATOR
			--
		do
			create Result.make_default
			binary_xml_build (file_path, Result)
		end

	new_serializeable (file_path: EL_FILE_PATH): EL_BUILDABLE_FROM_NODE_SCAN
		-- detect type from processing instruction
		local
			bex_file_path: EL_FILE_PATH
		do
			bex_file_path := bexml_path (file_path)
			convert_file_to_bexml (file_path, bex_file_path)
			smart_builder.build_from_file (bex_file_path)
			if smart_builder.has_item then
				Result := smart_builder.item
			end
		end

	new_smil_presentation (file_path: EL_FILE_PATH): SMIL_PRESENTATION
			--
		do
			create Result.make
			binary_xml_build (file_path, Result)
		end

	new_web_form (file_path: EL_FILE_PATH): WEB_FORM
			--
		do
			create Result.make
			binary_xml_build (file_path, Result)
		end

feature {NONE} -- Implementation

	bexml_path (file_path: EL_FILE_PATH): EL_FILE_PATH
		do
			Result := work_area_dir + file_path.base_sans_extension
			Result.add_extension (Extension_bexml)
		end

	binary_xml_build (file_path: EL_FILE_PATH; object: EL_CREATEABLE_FROM_NODE_SCAN)
		local
			bex_file_path: EL_FILE_PATH
		do
			bex_file_path := bexml_path (file_path)
			convert_file_to_bexml (file_path, bex_file_path)
			object.set_parser_type (Binary_encoded_event_source)
			object.build_from_file (bex_file_path)
		end

	convert_file_to_bexml (file_path, output_file_path: EL_FILE_PATH)
			--
		local
			bex_file: RAW_FILE
		do
			create bex_file.make_open_write (output_file_path)
			parse_event_generator.send_file (file_path, bex_file)
			bex_file.close
		end

feature {NONE} -- Internal attributes

	work_area_dir: EL_DIR_PATH

feature {NONE} -- Constants

	Binary_encoded_event_source: TYPE [EL_BINARY_ENCODED_PARSE_EVENT_SOURCE]
		once
			Result := {EL_BINARY_ENCODED_PARSE_EVENT_SOURCE}
		end

	Extension_bexml: STRING = "bexml"

	Parse_event_generator: EL_PARSE_EVENT_GENERATOR
		once
			create Result.make ({EL_EXPAT_XML_PARSER})
		end

end