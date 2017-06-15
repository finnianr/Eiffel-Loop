note
	description: "Summary description for {EIFFEL_SOURCE_TREE_EDIT_COMMAND_LINE_SUB_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-31 20:32:28 GMT (Wednesday 31st May 2017)"
	revision: "5"

deferred class
	EIFFEL_SOURCE_TREE_EDIT_COMMAND_LINE_SUB_APP

inherit
	TESTABLE_COMMAND_LINE_SUB_APPLICATION [EIFFEL_SOURCE_TREE_PROCESSOR]

feature -- Testing	

	test_run
			--
		do
			Test.do_file_tree_test ("Eiffel", agent test_source_tree, checksum)
		end

	test_source_tree (dir_path: EL_DIR_PATH)
		do
			create {EIFFEL_SOURCE_TREE_PROCESSOR} command.make (dir_path, new_editing_command)
			command.do_all
		end

	checksum: NATURAL
		deferred
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [
		source_path: EL_DIR_PATH; file_processor: EL_FILE_PROCESSING_COMMAND
	]
		do
			create Result
			Result.source_path := ""
			Result.file_processor := new_editing_command
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("source_tree", "Path to source code directory", << file_must_exist >>)
			>>
		end

	new_editing_command: EIFFEL_EDITING_COMMAND
		do
			create Result.make (new_editor)
		end

	new_editor: EL_EIFFEL_SOURCE_EDITOR
		deferred
		end

end
