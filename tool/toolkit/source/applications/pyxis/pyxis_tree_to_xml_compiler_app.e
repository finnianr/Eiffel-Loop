note
	description: "Compiles tree of Pyxis source files into single XML file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-31 20:31:42 GMT (Wednesday 31st May 2017)"
	revision: "4"

class
	PYXIS_TREE_TO_XML_COMPILER_APP

inherit
	TESTABLE_COMMAND_LINE_SUB_APPLICATION [PYXIS_TREE_TO_XML_COMPILER]
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
			create {PYXIS_TREE_TO_XML_COMPILER} command.make (source_tree_path, source_tree_path.parent + "localization.xml")
			normal_run
		end

feature {NONE} -- Implementation

	normal_initialize
		do
			Console.show ({PYXIS_TREE_TO_XML_COMPILER})
			Precursor
		end

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

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("source", "Source tree directory", << directory_must_exist >>),
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
				[{PYXIS_TREE_TO_XML_COMPILER_APP}, All_routines]
			>>
		end

end
