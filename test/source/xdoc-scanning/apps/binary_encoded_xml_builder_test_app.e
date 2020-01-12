note
	description: "[
		Runs tests found in [$source OBJECT_BUILDER_TEST_APP] using the event source type
		[$source EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 7:36:18 GMT (Sunday 12th January 2020)"
	revision: "10"

class
	BINARY_ENCODED_XML_BUILDER_TEST_APP

inherit
	OBJECT_BUILDER_TEST_SUB_APPLICATION
		redefine
			Option_name, visible_types
		end

create
	make

feature -- Tests

	test_run
			--
		local
			file: ZSTRING
		do
			-- 10 Jan 2020
			file := "linguistic-analysis.smil"
			do_file_test (file, agent new_smil_presentation, 4229411388)
			do_file_test (file, agent new_serializeable, 4229411388)

			file := "download-page.xhtml"
			do_file_test (file, agent new_web_form, 1209708169)
			do_file_test (file, agent new_serializeable, 1209708169)

			file := "request-matrix-sum.xml"
			do_file_test (file, agent new_matrix, 1069823838)
			do_file_test (file, agent new_serializeable, 1069823838)

			file := "request-matrix-average.xml"
			do_file_test (file, agent new_matrix, 570580005)
			do_file_test (file, agent new_serializeable, 570580005)
		end

feature {NONE} -- Factory

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
			Smart_builder.build_from_file (bex_file_path)
			if Smart_builder.has_item then
				Result := Smart_builder.item
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
			Result := file_path.with_new_extension (Extension_bexml)
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
			log.enter ("convert_file_to_bexml")
			create bex_file.make_open_write (output_file_path)
			parse_event_generator.send_file (file_path, bex_file)
			bex_file.close
			log.exit
		end

	visible_types: TUPLE [
		WEB_FORM, WEB_FORM_DROP_DOWN_LIST, WEB_FORM_COMPONENT, WEB_FORM_LINE_BREAK,
		SMIL_AUDIO_SEQUENCE, SMIL_AUDIO_CLIP, SMIL_PRESENTATION,
		MATRIX_CALCULATOR

--		EL_BINARY_ENCODED_XML_DOCUMENT_SCANNER,
--		EL_XML_PARSE_EVENT_GENERATOR
	]
		do
			create Result
		end

feature {NONE} -- Constants

	Binary_encoded_event_source: TYPE [EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE]
		once
			Result := {EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE}
		end

	Description: STRING = "Auto test remote builder concept"

	Extension_bexml: STRING = "bexml"

	Option_name: STRING = "bex_builder_test"

	Parse_event_generator: EL_PARSE_EVENT_GENERATOR
		once
			create Result.make ({EL_EXPAT_XML_PARSER})
		end

	Smart_builder: EL_SMART_BUILDABLE_FROM_NODE_SCAN
		once
			create Result.make (Binary_encoded_event_source)
		end

end
