note
	description: "Compiles tree of Pyxis source files into single XML file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-26 14:21:12 GMT (Saturday 26th June 2021)"
	revision: "13"

class
	PYXIS_TREE_TO_XML_COMPILER_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [PYXIS_TREE_TO_XML_COMPILER]
		rename
			extra_log_filter_set as empty_log_filter_set
		redefine
			Option_name, normal_initialize
		end

create
	make

feature -- Testing

	test_run
			--
		do
			Test.do_file_tree_test ("pyxis/localization", agent test_compile, 3855455161)
		end

	test_compile (source_tree_path: EL_DIR_PATH)
			--
		do
			log.put_new_line
			create {PYXIS_TREE_TO_XML_COMPILER} command.make ("", source_tree_path, source_tree_path.parent + "localization.xml")
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_optional_argument ("manifest", "Path to manifest of directories and files", << file_must_exist >>),
				valid_optional_argument ("source", "Source tree directory", << directory_must_exist >>),
				required_argument ("output", "Output file path")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "", "")
		end

	normal_initialize
		do
			Console.show ({PYXIS_TREE_TO_XML_COMPILER})
			Precursor
		end

feature {NONE} -- Constants

	Option_name: STRING = "pyxis_compile"

	Description: STRING = "Compile tree of Pyxis source files into single XML file"

end