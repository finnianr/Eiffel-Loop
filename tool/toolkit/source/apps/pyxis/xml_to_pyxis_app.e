note
	description: "Xml to pyxis app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "8"

class
	XML_TO_PYXIS_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [XML_TO_PYXIS_CONVERTER]
		rename
			command as converter
		undefine
			Test_data_dir
		redefine
			Option_name, normal_run
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_OS

create
	make

feature -- Basic operations

	normal_run
		do
			if converter.is_convertable then
				converter.execute
			end
		end

	test_run
			--
		do
--			Test.do_file_test (File.joined_path ("XML", "configuration.xsd"), agent test_bkup_to_pyxis, 0)
			Test.do_file_tree_test ("XML", agent test_xml_to_pyxis, 3039119155)
		end

feature -- Test

	test_xml_to_pyxis (a_dir_path: EL_DIR_PATH)
			--
		do
			across OS.file_list (a_dir_path, "*") as file_path loop
				create converter.make (file_path.item)
				normal_run
			end
		end

	test_bkup_to_pyxis (a_file_path: EL_FILE_PATH)
		do
			create converter.make (a_file_path)
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("in", "Path to XML source file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like converter}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "xml_to_pyxis"

	Description: STRING = "Convert xml file to pyxis"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{XML_TO_PYXIS_APP}, All_routines],
				[{XML_TO_PYXIS_CONVERTER}, All_routines]
			>>
		end

end
