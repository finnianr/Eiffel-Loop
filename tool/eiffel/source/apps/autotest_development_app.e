note
	description: "Convenience class to develop AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:18:04 GMT (Thursday 29th June 2017)"
	revision: "7"

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
--			do_file_data_test (agent publisher_test_set.test_publisher)
			do_file_data_test (agent publisher_test_set.test_regression (1774969085))
--			do_file_data_test (agent note_editor_test_set.test_editor_with_new_class)
		end

feature {NONE} -- Test

	publisher_test_set: REPOSITORY_PUBLISHER_TEST_SET
		do
			create Result
		end

	note_editor_test_set: NOTE_EDITOR_TEST_SET
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
				[{REPOSITORY_PUBLISHER_TEST_SET}, All_routines]
			>>
		end

end
