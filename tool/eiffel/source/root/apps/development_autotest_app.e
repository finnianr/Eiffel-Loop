note
	description: "Finalized executable tests for sub-applications"
	notes: "[
		Command option: `-development_autotest'
		
		**Test Sets**
		
			[$source NOTE_EDITOR_TEST_SET]
			[$source UNDEFINE_PATTERN_COUNTER_TEST_SET]
			[$source REPOSITORY_PUBLISHER_TEST_SET]
			[$source REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 14:24:08 GMT (Friday 14th February 2020)"
	revision: "25"

class
	DEVELOPMENT_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION
		redefine
			log_filter
		end

create
	make

feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{DEVELOPMENT_AUTOTEST_APP}, All_routines],
				[{EIFFEL_CONFIGURATION_FILE}, All_routines],
				[{EIFFEL_CONFIGURATION_INDEX_PAGE}, All_routines],
				[{NOTE_EDITOR_TEST_SET}, All_routines],
				[{REPOSITORY_PUBLISHER_TEST_SET}, All_routines],
				[{REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET}, All_routines],
				[{UNDEFINE_PATTERN_COUNTER_TEST_SET}, All_routines],
				[{TEST_UNDEFINE_PATTERN_COUNTER_COMMAND}, All_routines]
			>>
		end

	test_type: TUPLE [REPOSITORY_PUBLISHER_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [
		NOTE_EDITOR_TEST_SET,
		UNDEFINE_PATTERN_COUNTER_TEST_SET,
		REPOSITORY_PUBLISHER_TEST_SET,
		REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET
	]
		do
			create Result
		end

end
