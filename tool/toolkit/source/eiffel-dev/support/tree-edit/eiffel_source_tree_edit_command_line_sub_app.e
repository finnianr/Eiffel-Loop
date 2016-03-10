note
	description: "Summary description for {EIFFEL_SOURCE_TREE_EDIT_COMMAND_LINE_SUB_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "5"

deferred class
	EIFFEL_SOURCE_TREE_EDIT_COMMAND_LINE_SUB_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [EIFFEL_SOURCE_TREE_PROCESSOR]

feature -- Testing	

	test_run
			--
		do
			Test.do_file_tree_test ("Eiffel", agent test_source_tree, checksum)
		end

	test_source_tree (dir_path: EL_DIR_PATH)
		do
			create {EIFFEL_SOURCE_TREE_PROCESSOR} command.make (dir_path, create_file_editor)
			command.do_all
		end

	checksum: NATURAL
		deferred
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [
		source_path: EL_DIR_PATH; file_processor: EL_FILE_PROCESSOR
	]
		do
			create Result
			Result.source_path := ""
			Result.file_processor := create_file_editor
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("source_tree", "Path to source code directory")
			>>
		end

	create_file_editor: EIFFEL_SOURCE_EDITING_PROCESSOR
		deferred
		end

end
