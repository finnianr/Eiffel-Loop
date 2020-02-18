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
	date: "2020-02-18 13:52:40 GMT (Tuesday 18th February 2020)"
	revision: "26"

class
	AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION
		redefine
			new_log_filter_list, visible_types
		end

create
	make

feature {NONE} -- Implementation

	new_log_filter_list: EL_ARRAYED_LIST [EL_LOG_FILTER]
			--
		do
			Result := Precursor +
				new_log_filter ({EIFFEL_CONFIGURATION_FILE}, All_routines) +
				new_log_filter ({EIFFEL_CONFIGURATION_INDEX_PAGE}, All_routines)
		end

	test_type: TUPLE [FEATURE_EDITOR_COMMAND_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [
		UNDEFINE_PATTERN_COUNTER_TEST_SET,
		REPOSITORY_PUBLISHER_TEST_SET,
		REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET,
		NOTE_EDITOR_TEST_SET
	]
		do
			create Result
		end

	visible_types: TUPLE [FEATURE_EDITOR_COMMAND]
		do
			create Result
		end

end
