note
	description: "Summary description for {ECF_TO_PECF_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 12:12:25 GMT (Thursday 29th June 2017)"
	revision: "6"

class
	ECF_TO_PECF_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [EL_DIRECTORY_TREE_FILE_PROCESSOR]
		rename
			command as tree_processor
		redefine
			Option_name, tree_processor, normal_run
		end

create
	make

feature -- Basic operations

	test_run
			--
		do
			Test.do_file_tree_test ("ECF", agent test_xml_to_pyxis, 3319767416)
		end

	normal_run
		do
			tree_processor.set_file_pattern ("*.ecf")
			Precursor
		end

feature -- Test

	test_xml_to_pyxis (a_dir_path: EL_DIR_PATH)
			--
		do
			create tree_processor.make (a_dir_path, create {XML_TO_PYXIS_CONVERTER})
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent tree_processor.make
		end

	default_operands: TUPLE [dir_path: EL_DIR_PATH; processor: EL_FILE_PROCESSING_COMMAND]
		do
			create Result
			Result.dir_path := ""
			Result.processor := create {XML_TO_PYXIS_CONVERTER}
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument (
					"library_tree", "Path to Eiffel library/projects directory tree", << file_must_exist >>
				)
			>>
		end

	tree_processor: EL_DIRECTORY_TREE_FILE_PROCESSOR

feature {NONE} -- Constants

	Option_name: STRING = "ecf_to_pecf"

	Description: STRING = "Convert Eiffel configuration files to Pyxis format"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{ECF_TO_PECF_APP}, All_routines],
				[{XML_TO_PYXIS_CONVERTER}, All_routines]
			>>
		end

end
