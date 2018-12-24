note
	description: "Source tree edit command line sub app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-23 16:27:52 GMT (Sunday 23rd December 2018)"
	revision: "9"

deferred class
	SOURCE_TREE_EDIT_COMMAND_LINE_SUB_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [SOURCE_TREE_PROCESSOR]

feature -- Testing	

	test_run
			--
		do
			Test.do_file_tree_test ("latin1-sources", agent test_source_tree, checksum)
		end

	test_source_tree (dir_path: EL_DIR_PATH)
		do
			create {SOURCE_TREE_PROCESSOR} command.make (dir_path, new_editing_command)
			command.do_all
		end

	checksum: NATURAL
		deferred
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("source_tree", "Path to source code directory", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("", new_editing_command)
		end

	new_editing_command: EDITING_COMMAND
		do
			create Result.make (new_editor)
		end

	new_editor: EL_EIFFEL_SOURCE_EDITOR
		deferred
		end

end
