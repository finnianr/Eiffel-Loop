note
	description: "Finalized executable tests for sub-applications"
	notes: "[
		Command option: `-autotest'
		
		**Test Sets**
		
			[$source FEATURE_EDITOR_COMMAND_TEST_SET]
			[$source PATH_TEST_SET]
			[$source PYXIS_ECF_PARSER_TEST_SET]
			[$source REPOSITORY_PUBLISHER_TEST_SET]
			[$source REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET]
			[$source TRANSLATION_TREE_COMPILER_TEST_SET]
			[$source UNDEFINE_PATTERN_COUNTER_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-04 17:12:51 GMT (Tuesday 4th January 2022)"
	revision: "45"

class
	AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [
		CLASS_RENAMING_TEST_SET,
		FEATURE_EDITOR_COMMAND_TEST_SET,
		NOTE_EDITOR_TEST_SET,
		PATH_TEST_SET,
		PYXIS_ECF_PARSER_TEST_SET,
		REPOSITORY_PUBLISHER_TEST_SET,
		REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET,
		TRANSLATION_TREE_COMPILER_TEST_SET,
		UNDEFINE_PATTERN_COUNTER_TEST_SET
	]
		redefine
			new_log_filter_set, visible_types
		end

create
	make

feature {NONE} -- Implementation

	new_log_filter_set: EL_LOG_FILTER_SET [TUPLE]
			--
		do
			Result := Precursor
			Result.show_all ({EIFFEL_CONFIGURATION_FILE})
			Result.show_all ({EIFFEL_CONFIGURATION_INDEX_PAGE})
		end

	visible_types: TUPLE [
		FEATURE_EDITOR_COMMAND,
		PYXIS_TRANSLATION_TREE_COMPILER,
		REPOSITORY_TEST_PUBLISHER,
		UNDEFINE_PATTERN_COUNTER_COMMAND
	]
		do
			create Result
		end

end