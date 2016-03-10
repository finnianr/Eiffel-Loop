note
	description: "Summary description for {PYXIS_TO_XML_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-02-20 11:59:51 GMT (Thursday 20th February 2014)"
	revision: "6"

class
	PYXIS_TO_XML_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [PYXIS_TO_XML_CONVERTER]
		redefine
			Option_name, ask_user_to_quit
		end

create
	make

feature -- Testing

	test_run
			--
		do
--			Test.do_file_test ("pyxis/translations.xml.pyx", agent test_pyxis_to_xml, 2577335766)

--			Test.do_file_test ("pyxis/translations.xml.pyx", agent test_pyxis_to_xml_from_string_medium, 1044910295)

--			Test.do_file_test ("pyxis/translations.xml.pyx", agent test_pyxis_parser, 1282092045)

--			Test.do_file_test ("pyxis/eiffel-loop.pecf", agent test_pyxis_to_xml, 3829952929)

--			Test.do_file_test ("pyxis/configuration.xsd.pyx", agent test_pyxis_to_xml, 638220420)


--			Test.do_file_test ("pyxis/eiffel-loop.2.pecf", agent test_pyxis_parser, 1282092045)

--			Test.do_file_test ("pyxis/XML XSL Example.xsl.pyx", agent test_pyxis_to_xml, 1300931316)

			Test.do_all_files_test ("pyxis" , "*", agent test_pyxis_to_xml, 3241462011)

		end

	test_pyxis_to_xml (a_file_path: EL_FILE_PATH)
			--
		do
			create {PYXIS_TO_XML_CONVERTER} command.make (a_file_path, create {EL_FILE_PATH})
			normal_run
		end

	test_pyxis_to_xml_from_string_medium (a_file_path: EL_FILE_PATH)
		local
			pyxis_in: EL_TEXT_IO_MEDIUM
			xml_generator: EL_PYXIS_XML_TEXT_GENERATOR
			file_out: PLAIN_TEXT_FILE
		do
			create  pyxis_in.make_open_read_from_string (File_system.plain_text (a_file_path))
			create file_out.make_open_write (a_file_path.without_extension.unicode)
			create xml_generator.make
			xml_generator.convert_stream (pyxis_in, file_out)
			file_out.close
		end

	test_pyxis_parser (file_path: EL_FILE_PATH)
			--
		local
			document_logger: EL_XML_DOCUMENT_LOGGER
			pyxis_file: PLAIN_TEXT_FILE
		do
			log.enter_with_args ("test_pyxis_parser", << file_path.to_string >>)
			create pyxis_file.make_open_read (file_path.unicode)
			create document_logger.make_pyxis_source
			document_logger.scan_from_stream (pyxis_file)
			pyxis_file.close
			log.exit
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [source_path, output_path: EL_FILE_PATH]
		do
			create Result
			Result.source_path := ""
			Result.output_path := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("in", "Input file path"),
				optional_argument ("out", "Output file path")
			>>
		end

	ask_user_to_quit: BOOLEAN
			--
		do
			Result := Args.word_option_exists ("remain")
		end

feature {NONE} -- Constants

	Option_name: STRING = "pyxis_to_xml"

	Description: STRING = "Convert pyxis file to xml"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{PYXIS_TO_XML_APP}, "*"],
				[{EL_PYXIS_PARSER}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{EL_XML_DOCUMENT_LOGGER}, "*"],
				[{PYXIS_TO_XML_CONVERTER}, "*"],
				[{EL_PYXIS_XML_TEXT_GENERATOR}, "*"]
			>>
		end


	list: EL_STRING_LIST [EL_ASTRING]
end
