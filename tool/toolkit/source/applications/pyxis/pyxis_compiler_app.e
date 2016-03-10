note
	description: "Summary description for {PYXIS_COMPILER_APP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PYXIS_COMPILER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [PYXIS_COMPILER]
		redefine
			Option_name
		end

create
	make

feature -- Testing

	test_run
			--
		do
			Test.do_file_tree_test ("pyxis/localization", agent test_compile, 3143367417)
		end

	test_compile (source_tree_path: EL_DIR_PATH)
			--
		do
			create {PYXIS_COMPILER} command.make (source_tree_path, source_tree_path.parent + "localization.xml")
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
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
				[{PYXIS_COMPILER}, All_routines],
				[{EL_TEST_ROUTINES}, All_routines]
			>>
		end

end
