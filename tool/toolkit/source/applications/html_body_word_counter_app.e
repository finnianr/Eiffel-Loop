note
	description: "Summary description for {HTML_BODY_WORD_COUNT_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-10-23 12:02:06 GMT (Friday 23rd October 2015)"
	revision: "8"

class
	HTML_BODY_WORD_COUNTER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [HTML_BODY_WORD_COUNTER]
		redefine
			Option_name
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

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [path: EL_DIR_PATH]
		do
			create Result
			Result.path := Directory.Current_working
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_argument ("path", "Directory path")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "body_word_counts"

	Description: STRING = "Count words in directory of html body files (*.body)"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{HTML_BODY_WORD_COUNTER_APP}, All_routines],
				[{EL_TEST_ROUTINES}, All_routines],
				[{HTML_BODY_WORD_COUNTER}, All_routines]

			>>
		end

end
