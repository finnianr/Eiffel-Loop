note
	description: "Source tree edit command line sub app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-07 10:40:22 GMT (Monday   7th   October   2019)"
	revision: "12"

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
			create {SOURCE_TREE_PROCESSOR} command.make (dir_path, agent new_editor)
			command.do_all
		end

	checksum: NATURAL
		deferred
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("source_tree", "Path to source code directory", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_DIR_PATH}, agent new_editor)
		end

	new_editor (file_path_list: LIST [EL_FILE_PATH]): EL_EIFFEL_SOURCE_EDITOR
		deferred
		end

end
