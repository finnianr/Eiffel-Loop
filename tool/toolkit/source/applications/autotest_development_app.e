note
	description: "Convenience class to develop AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-20 9:34:23 GMT (Wednesday 20th July 2016)"
	revision: "1"

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
			do_file_data_test (agent publisher_test_set.test_publisher)
--			do_file_data_test (agent note_editor_test_set.test_editor_with_new_class)
		end

feature {NONE} -- Test

	publisher_test_set: EIFFEL_REPOSITORY_PUBLISHER_TEST_SET
		do
			create Result
		end

	note_editor_test_set: EIFFEL_NOTE_EDITOR_TEST_SET
		do
			create Result
		end

feature {NONE} -- Constants

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{AUTOTEST_DEVELOPMENT_APP}, All_routines],
				[{REPOSITORY_SOURCE_TREE}, All_routines],
				[{REPOSITORY_SOURCE_TREE_PAGE}, All_routines],
				[{EIFFEL_NOTE_EDITOR_TEST_SET}, All_routines],
				[{EIFFEL_REPOSITORY_PUBLISHER_TEST_SET}, All_routines]
			>>
		end

end
