note
	description: "Summary description for {HTML_BODY_WORD_COUNT_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 11:52:19 GMT (Sunday 15th October 2017)"
	revision: "6"

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

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				required_argument ("path", "Directory path")
			>>
		end

	default_make: PROCEDURE
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
