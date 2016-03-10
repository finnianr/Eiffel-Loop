note
	description: "Summary description for {XML_REMOTE_BUILDER_TEST_APP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BEX_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP

inherit
	XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP
		redefine
			Option_name, Description, Log_filter, run, initialize, smart_build_file
		end

	EL_MODULE_PATH

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
			Test.do_all_files_test (Path.directory_name ("XML"), "*", agent smart_build_file, 2902699395)
		end

feature {NONE} -- Implementation

	smart_build_file (file_path: FILE_NAME)
			--
		do
			log.enter_with_args ("smart_build_file", << file_path >> )
			convert_file (file_path)
			smart_builder.build_from_binary_file (bexdat_extension (file_path))

			if attached {EL_XML_STORABLE} smart_builder.target as storable then
				storable.set_output_path (file_path)
				storable.store
			end
			log.exit
		end

	convert_file (file_path: FILE_NAME)
			--
		local
			xml_file: PLAIN_TEXT_FILE
			parse_event_generator: EL_XML_PARSE_EVENT_GENERATOR
			event_stream: RAW_FILE
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

	bexdat_extension (file_path: FILE_NAME): FILE_NAME
			--
		do
			create Result.make_from_string (file_path)
			Result.add_extension ("bexdat")
		end

	doc_scanner: BINARY_ENCODED_XML_DOCUMENT_SCANNER

feature {NONE} -- Constants

	Option_name: STRING = "test_bex_x2e_and_e2x"

	Description: STRING = "Auto test remote builder concept"

	Log_filter: ARRAY [TUPLE]
			--
		once
			Result := <<
				["BEX_XML_TO_EIFFEL_OBJECT_BUILDER_TEST_APP", "*"],

				["BINARY_ENCODED_XML_DOCUMENT_SCANNER",
					"on_start_tag",
					"on_end_tag",
					"on_content"
				],
				["-EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE", "*"]

			>>
		end

end
