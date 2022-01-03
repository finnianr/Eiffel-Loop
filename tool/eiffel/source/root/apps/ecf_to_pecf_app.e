note
	description: "Command-line interface to [$source EL_DIRECTORY_TREE_FILE_PROCESSOR] command"
	to_do: "[
		* 1st Aug 2020 Throw an exception for invalid cluster names in form doc/config.pyx
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:50 GMT (Monday 3rd January 2022)"
	revision: "20"

class
	ECF_TO_PECF_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [EL_DIRECTORY_TREE_FILE_PROCESSOR]
		rename
			command as tree_processor,
			extra_log_filter_set as empty_log_filter_set
		redefine
			Option_name
		end

create
	make

feature -- Basic operations

	test_run
			--
		do
			Test.do_file_tree_test ("ECF", agent test_xml_to_pyxis, 3319767416)
		end

feature -- Test

	test_xml_to_pyxis (a_dir_path: DIR_PATH)
			--
		do
			create tree_processor.make (a_dir_path, "*.ecf", create {XML_TO_PYXIS_CONVERTER}.make_default)
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument (
					"library_tree", "Path to Eiffel library/projects directory tree", << file_must_exist >>
				)
			>>
		end

	default_make: PROCEDURE [like tree_processor]
		do
			Result := agent {like tree_processor}.make (
				create {DIR_PATH}, "*.ecf", create {XML_TO_PYXIS_CONVERTER}.make_default
			)
		end

feature {NONE} -- Constants

	Option_name: STRING = "ecf_to_pecf"

	Description: STRING = "Convert Eiffel configuration files to Pyxis format"

end