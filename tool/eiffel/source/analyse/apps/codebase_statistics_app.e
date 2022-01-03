note
	description: "[
		A command line interface to the command [$source CODEBASE_STATISTICS_COMMAND].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:50 GMT (Monday 3rd January 2022)"
	revision: "18"

class
	CODEBASE_STATISTICS_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [CODEBASE_STATISTICS_COMMAND]
		rename
			extra_log_filter_set as empty_log_filter_set
		redefine
			Option_name
		end

feature -- Testing

	test_note_edit (a_sources_path: DIR_PATH)
			--
		do
			create command.make (a_sources_path + "manifest.pyx", create {EL_DIR_PATH_ENVIRON_VARIABLE})
			normal_run
		end

	test_run
			--
		do
			Test.do_file_tree_test ("latin1-sources", agent test_note_edit, 1404346495)
			Test.do_file_tree_test ("utf8-sources", agent test_note_edit, 191337464)
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("sources", "Path to sources manifest file", << file_must_exist >>),
				optional_argument ("define", "Define an environment variable: name=<value>")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", create {EL_DIR_PATH_ENVIRON_VARIABLE})
		end

feature {NONE} -- Constants

	Description: STRING = "[
		Count lines of eiffel code for combined source trees defined by a source tree manifest. 
		Lines are counted starting from the class keyword and exclude comments and blank lines.
	]"

	Option_name: STRING = "codebase_stats"

end