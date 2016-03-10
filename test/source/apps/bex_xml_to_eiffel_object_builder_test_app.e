note
	description: "Summary description for {XML_REMOTE_BUILDER_TEST_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:24:40 GMT (Monday 24th June 2013)"
	revision: "2"

class
	BEX_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP

inherit
	XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP
		redefine
			Option_name, Description, Log_filter, run, initialize, smart_build_file
		end

	EL_MODULE_TEST

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			Precursor
			create doc_scanner.make
		end

feature -- Basic operations

	run
			--
		do
			Test.do_all_files_test ("XML", "*", agent smart_build_file, 2902699395)
		end

feature {NONE} -- Implementation

	smart_build_file (file_path: EL_FILE_PATH)
			--
		do
			log.enter_with_args ("smart_build_file", << file_path >> )
			convert_file (file_path)
			smart_builder.build_from_binary_file (bexdat_extension (file_path))

			if attached {EL_BUILDABLE_XML_FILE_PERSISTENT} smart_builder.target as storable then
				storable.set_output_path (file_path)
				storable.store
			end
			log.exit
		end

	convert_file (file_path: EL_FILE_PATH)
			--
		local
			xml_file: PLAIN_TEXT_FILE
			parse_event_generator: EL_XML_PARSE_EVENT_GENERATOR
			event_stream: RAW_FILE
		do
			log.enter ("parse_from_file")
			create event_stream.make_open_write (bexdat_extension (file_path).unicode)
			create parse_event_generator.make_with_output (event_stream)
			create xml_file.make_open_read (file_path.unicode)

			parse_event_generator.send (xml_file)

			xml_file.close
			event_stream.close
			log.exit
		end

	bexdat_extension (file_path: EL_FILE_PATH): EL_FILE_PATH
			--
		do
			Result := file_path.twin
			Result.add_extension ("bexdat")
		end

	doc_scanner: BINARY_ENCODED_XML_DOCUMENT_SCANNER

feature {NONE} -- Constants

	Option_name: STRING = "test_bex_x2e_and_e2x"

	Description: STRING = "Auto test remote builder concept"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		local
			extras: ARRAYED_LIST [like Type_logging_filter]
		do
			create extras.make_from_array (<<
				[{BEX_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP}, "*"],
				[{BINARY_ENCODED_XML_DOCUMENT_SCANNER}, "on_start_tag, on_end_tag, on_content"],
				[{EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE}, "-*"]

			>>)
			extras.append (create {ARRAYED_LIST [like Type_logging_filter]}.make_from_array (Precursor))
			Result := extras.to_array
		end

end
