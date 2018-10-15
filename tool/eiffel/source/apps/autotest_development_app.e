note
	description: "Convenience class to develop AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-03 11:04:03 GMT (Wednesday 3rd October 2018)"
	revision: "15"

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
			do_file_data_test (agent publisher.test_regression (1090107716))
--			do_file_data_test (agent undefine_pattern_counter.test_command)
--			do_file_data_test (agent note_editor.test_editor_with_new_class)
--			do_file_data_test (agent link_expander.test_regression (1653260098))
		end

feature {NONE} -- Test

	publisher: REPOSITORY_PUBLISHER_TEST_SET
		do
			create Result
		end

	link_expander: REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET
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
				[{EIFFEL_CONFIGURATION_FILE}, All_routines],
				[{EIFFEL_CONFIGURATION_INDEX_PAGE}, All_routines],
				[{NOTE_EDITOR_TEST_SET}, All_routines],
				[{REPOSITORY_PUBLISHER_TEST_SET}, All_routines],
				[{REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET}, All_routines],
				[{UNDEFINE_PATTERN_COUNTER_TEST_SET}, All_routines],
				[{TEST_UNDEFINE_PATTERN_COUNTER_COMMAND}, All_routines]
			>>
		end

end
