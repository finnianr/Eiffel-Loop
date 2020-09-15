note
	description: "Finalized executable tests for sub-applications"
	notes: "[
		Command option: `-autotest'
		
		**Test Sets**
		
			[$source UNDEFINE_PATTERN_COUNTER_TEST_SET]
			[$source REPOSITORY_PUBLISHER_TEST_SET]
			[$source REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-15 10:25:59 GMT (Tuesday 15th September 2020)"
	revision: "35"

class
	AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [TUPLE [
		FEATURE_EDITOR_COMMAND_TEST_SET,
		UNDEFINE_PATTERN_COUNTER_TEST_SET,
		REPOSITORY_PUBLISHER_TEST_SET,
		REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET,
		TRANSLATION_TREE_COMPILER_TEST_SET
	]]
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

	visible_types: TUPLE [UNDEFINE_PATTERN_COUNTER_COMMAND, PYXIS_TRANSLATION_TREE_COMPILER]
		do
			create Result
		end

end