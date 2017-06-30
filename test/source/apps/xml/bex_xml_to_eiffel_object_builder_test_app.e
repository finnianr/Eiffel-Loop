note
	description: "Summary description for {XML_REMOTE_BUILDER_TEST_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 12:27:14 GMT (Thursday 29th June 2017)"
	revision: "4"

class
	BEX_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP

inherit
	OBJECT_BUILDER_TEST_APP
		redefine
			Option_name, Description, log_filter_list, run, initialize, new_smart_builder
		end

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			Precursor
			create doc_scanner.make ({EL_EXPAT_XML_PARSER})
		end

feature -- Basic operations

	run
			--
		do
			Test.do_all_files_test ("XML", All_routines, agent smart_build_file, 2902699395)
		end

feature {NONE} -- Implementation

	bexdat_extension (file_path: EL_FILE_PATH): EL_FILE_PATH
			--
		do
			Result := file_path.twin
			Result.add_extension ("bexdat")
		end

	convert_file (file_path: EL_FILE_PATH)
			--
		local
			xml_file: PLAIN_TEXT_FILE; event_stream: RAW_FILE
			parse_event_generator: EL_XML_PARSE_EVENT_GENERATOR
		do
			log.enter ("parse_from_file")
			create event_stream.make_open_write (bexdat_extension (file_path))
			create parse_event_generator.make_with_output (event_stream)
			create xml_file.make_open_read (file_path)

			parse_event_generator.send (xml_file)

			xml_file.close
			event_stream.close
			log.exit
		end

	new_smart_builder: EL_SMART_BUILDABLE_FROM_NODE_SCAN
		do
			create Result.make ({EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE})
		end

feature {NONE} -- Internal attributes

	doc_scanner: BINARY_ENCODED_XML_DOCUMENT_SCANNER

feature {NONE} -- Constants

	Description: STRING = "Auto test remote builder concept"

	log_filter_list: ARRAYED_LIST [EL_LOG_FILTER]
			--
		do
			Result := Precursor
			Result.extend (new_log_filter ({BEX_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP}, All_routines))
			Result.extend (new_log_filter ({BINARY_ENCODED_XML_DOCUMENT_SCANNER}, "on_start_tag, on_end_tag, on_content"))
		end

	Option_name: STRING = "bex_x2e_and_e2x"

end
