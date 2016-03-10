note
	description: "Summary description for {XML_TO_PYXIS_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-26 14:32:36 GMT (Friday 26th June 2015)"
	revision: "7"

class
	XML_TO_PYXIS_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [XML_TO_PYXIS_CONVERTER]
		rename
			command as converter
		redefine
			Option_name, converter, normal_run
		end

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
			across File_system.file_list (a_dir_path, "*") as file_path loop
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

	make_action: PROCEDURE [like converter, like default_operands]
		do
			Result := agent converter.make
		end

	default_operands: TUPLE [source_path: EL_FILE_PATH]
		do
			create Result
			Result.source_path := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("in", "Path to XML source file")
			>>
		end

	converter: XML_TO_PYXIS_CONVERTER

feature {NONE} -- Constants

	Option_name: STRING = "xml_to_pyxis"

	Description: STRING = "Convert xml file to pyxis"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{XML_TO_PYXIS_APP}, All_routines],
				[{EL_TEST_ROUTINES}, All_routines],
				[{XML_TO_PYXIS_CONVERTER}, All_routines]
			>>
		end

end
