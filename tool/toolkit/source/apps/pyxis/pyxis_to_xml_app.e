note
	description: "Summary description for {PYXIS_TO_XML_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 11:48:46 GMT (Sunday 15th October 2017)"
	revision: "9"

class
	PYXIS_TO_XML_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [PYXIS_TO_XML_CONVERTER]
		redefine
			Option_name
		end

create
	make

feature -- Testing

--	normal_run
--		do
--		end

	test_run
			--
		do
--			Test.do_all_files_test ("pyxis/localization", "*.pyx", agent test_pyxis_to_xml, 2102789230)
--			Test.do_all_files_test ("pyxis", "*", agent test_pyxis_to_xml, 2885827006)

--			Test.do_file_test ("pyxis/translations.xml.pyx", agent test_pyxis_to_xml_from_string_medium, 1044910295)

--			Test.do_file_test ("pyxis/translations.xml.pyx", agent test_pyxis_parser, 1282092045)

			Test.do_file_test ("pyxis/eiffel-loop.pecf", agent test_pyxis_to_xml, 1939476645)

--			Test.do_file_test ("pyxis/configuration.xsd.pyx", agent test_pyxis_to_xml, 638220420)


--			Test.do_file_test ("pyxis/eiffel-loop.2.pecf", agent test_pyxis_parser, 1282092045)

--			Test.do_file_test ("pyxis/XML XSL Example.xsl.pyx", agent test_pyxis_to_xml, 1300931316)

		end

	test_pyxis_to_xml (a_file_path: EL_FILE_PATH)
			--
		do
			create {PYXIS_TO_XML_CONVERTER} command.make (a_file_path, create {EL_FILE_PATH})
			normal_run
		end

	test_pyxis_parser (file_path: EL_FILE_PATH)
			--
		local
			document_logger: EL_XML_DOCUMENT_LOGGER
			pyxis_file: PLAIN_TEXT_FILE
		do
			log.enter_with_args ("test_pyxis_parser", << file_path.to_string >>)
			create pyxis_file.make_open_read (file_path)
			create document_logger.make ({EL_PYXIS_PARSER})
			document_logger.scan_from_stream (pyxis_file)
			pyxis_file.close
			log.exit
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("in", "Input file path", << file_must_exist >>),
				optional_argument ("out", "Output file path")
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("", "")
		end

feature {NONE} -- Constants

	Option_name: STRING = "pyxis_to_xml"

	Description: STRING = "Convert pyxis file to xml"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{PYXIS_TO_XML_APP}, All_routines],
				[{PYXIS_TO_XML_CONVERTER}, All_routines]
			>>
		end

end
