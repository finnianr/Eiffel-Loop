note
	description: "[
		A command line interface to the [$source HTML_BODY_WORD_COUNTER] class.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 15:25:53 GMT (Wednesday 25th September 2019)"
	revision: "10"

class
	HTML_BODY_WORD_COUNTER_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [HTML_BODY_WORD_COUNTER]
		undefine
			Test_data_dir
		redefine
			Option_name
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS
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

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{HTML_BODY_WORD_COUNTER_APP}, All_routines],
				[{HTML_BODY_WORD_COUNTER}, All_routines]
			>>
		end

end
