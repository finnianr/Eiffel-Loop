note
	description: "Summary description for {HTML_BODY_WORD_COUNT_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-19 6:35:19 GMT (Tuesday 19th July 2016)"
	revision: "1"

class
	HTML_BODY_WORD_COUNTER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [HTML_BODY_WORD_COUNTER]
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
				[{HTML_BODY_WORD_COUNTER}, All_routines]

			>>
		end

end