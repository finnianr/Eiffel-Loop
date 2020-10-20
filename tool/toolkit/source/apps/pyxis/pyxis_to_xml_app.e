note
	description: "Command line interface to command [$source EL_PYXIS_TO_XML_CONVERTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-20 10:29:11 GMT (Tuesday 20th October 2020)"
	revision: "22"

class
	PYXIS_TO_XML_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [EL_PYXIS_TO_XML_CONVERTER]
		rename
			extra_log_filter as no_log_filter
		undefine
			test_data_dir
		redefine
			Option_name, visible_types
		end

	EIFFEL_LOOP_TEST_CONSTANTS
		rename
			EL_test_data_dir as test_data_dir
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

--			Test.do_all_files_test ("pyxis/localization", "*.pyx", agent test_pyxis_to_xml, 1611293559)
			Test.do_all_files_test ("pyxis", "*", agent test_pyxis_to_xml, 1430741711)

--			Test.do_file_test ("pyxis/eiffel-loop.2.pecf", agent test_pyxis_parser, 1282092045)

		end

	test_pyxis_to_xml (a_file_path: EL_FILE_PATH)
			--
		do
			create {EL_PYXIS_TO_XML_CONVERTER} command.make (a_file_path, create {EL_FILE_PATH})
			normal_run
		end

	test_pyxis_parser (file_path: EL_FILE_PATH)
			--
		local
			document_logger: EL_XML_DOCUMENT_LOGGER
			pyxis_file: PLAIN_TEXT_FILE
		do
			log.enter_with_args ("test_pyxis_parser", [file_path])
			create pyxis_file.make_open_read (file_path)
			create document_logger.make ({EL_PYXIS_PARSER})
			document_logger.scan_from_stream (pyxis_file)
			pyxis_file.close
			log.exit
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("in", "Input file path", << file_must_exist >>),
				optional_argument ("out", "Output file path")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "")
		end

	visible_types: TUPLE [EL_PYXIS_TO_XML_CONVERTER]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "pyxis_to_xml"

	Description: STRING = "Convert Pyxis format file to XML"

end