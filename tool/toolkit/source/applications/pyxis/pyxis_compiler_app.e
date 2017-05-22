note
	description: "Compiles tree of Pyxis source files into single XML file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-19 6:35:19 GMT (Tuesday 19th July 2016)"
	revision: "1"

class
	PYXIS_COMPILER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [PYXIS_COMPILER]
		redefine
			Option_name
		end

create
	make

feature -- Testing

	test_run
			--
		do
			Test.do_file_tree_test ("pyxis/localization", agent test_compile, 3357932840)
		end

	test_compile (source_tree_path: EL_DIR_PATH)
			--
		do
			create {PYXIS_COMPILER} command.make (source_tree_path, source_tree_path.parent + "localization.xml")
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [source_path: EL_DIR_PATH; output_path: EL_FILE_PATH]
		do
			create Result
			Result.source_path := ""
			Result.output_path := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("source", "Source tree directory"),
				required_argument ("output", "Output file path")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "pyxis_compile"

	Description: STRING = "Compile tree of Pyxis source files into single XML file"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{PYXIS_COMPILER_APP}, All_routines],
				[{PYXIS_COMPILER}, All_routines]
			>>
		end

end