note
	description: "[
		A command line interface to the [$source HTML_BODY_WORD_COUNTER] class.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-10 10:08:14 GMT (Tuesday 10th November 2020)"
	revision: "16"

class
	HTML_BODY_WORD_COUNTER_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [HTML_BODY_WORD_COUNTER]
		rename
			extra_log_filter_set as empty_log_filter_set
		undefine
			Test_data_dir
		redefine
			Option_name
		end

	EIFFEL_LOOP_TEST_CONSTANTS
		rename
			EL_test_data_dir as Test_data_dir
		end

create
	make

feature -- Test

	test_run
			--
		do
			Test.do_file_tree_test ("docs/html/I Ching", agent test_count, 3689436838)
		end

	test_count (a_dir_path: EL_DIR_PATH)
			--
		do
			create command.make (a_dir_path)
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("path", "Directory path")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (Directory.Current_working)
		end

feature {NONE} -- Constants

	Option_name: STRING = "body_word_counts"

	Description: STRING = "Count words in directory of html body files (*.body)"

end