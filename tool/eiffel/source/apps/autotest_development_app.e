note
	description: "Convenience class to develop AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-11 15:18:14 GMT (Wednesday 11th April 2018)"
	revision: "10"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	run
		do
--			do_file_data_test (agent publisher.test_publisher)
			do_file_data_test (agent publisher.test_regression (155518232))
--			do_file_data_test (agent undefine_pattern_counter.test_command)
--			do_file_data_test (agent note_editor.test_editor_with_new_class)
		end

feature {NONE} -- Test

	publisher: REPOSITORY_PUBLISHER_TEST_SET
		do
			create Result
		end

	note_editor: NOTE_EDITOR_TEST_SET
		do
			create Result
		end

	undefine_pattern_counter: UNDEFINE_PATTERN_COUNTER_TEST_SET
		do
			create Result
		end

feature {NONE} -- Constants

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{AUTOTEST_DEVELOPMENT_APP}, All_routines],
				[{REPOSITORY_SOURCE_TREE}, All_routines],
				[{REPOSITORY_SOURCE_TREE_PAGE}, All_routines],
				[{NOTE_EDITOR_TEST_SET}, All_routines],
				[{REPOSITORY_PUBLISHER_TEST_SET}, All_routines],
				[{UNDEFINE_PATTERN_COUNTER_TEST_SET}, All_routines],
				[{TEST_UNDEFINE_PATTERN_COUNTER_COMMAND}, All_routines]
			>>
		end

end
