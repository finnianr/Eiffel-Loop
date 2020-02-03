note
	description: "Sub-application to call tests in descendants of `EQA_TEST_SET'"
	notes: "[
		Command option: `-base_autotest'

		**Tests**

		[$source CHAIN_TEST_SET]
		[$source DATE_TEXT_TEST_SET]
		[$source FILE_AND_DIRECTORY_TEST_SET]
		[$source GENERAL_TEST_SET]
		[$source STRING_LIST_TEST_SET]
		[$source SUBSTITUTION_TEMPLATE_TEST_SET]
		[$source TEMPLATE_TEST_SET]
		[$source URI_ENCODING_TEST_SET]
		[$source ZSTRING_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-03 16:39:41 GMT (Monday 3rd February 2020)"
	revision: "74"

class
	BASE_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_STRING_32_TEMPLATE, EL_LINKED_STRING_LIST [STRING_GENERAL],
		EL_MAKEABLE_FROM_STRING [STRING_GENERAL],
		EL_SHARED_INITIALIZER [EL_INITIALIZEABLE],
		EL_EXTERNAL_LIBRARY [EL_INITIALIZEABLE]
	]
		-- Compile classes for maintenance
		do
			create Result
		end

	test_sets: TUPLE [
		DIGEST_ROUTINES_TEST_SET, DIR_URI_PATH_TEST_SET,
		GENERAL_TEST_SET,
		PATH_TEST_SET, PATH_STEPS_TEST_SET,
		REFLECTION_TEST_SET,
		STRING_EDITION_HISTORY_TEST_SET, STRING_EDITOR_TEST_SET,
		SE_ARRAY2_TEST_SET, STRING_32_ROUTINES_TEST_SET,
		TEMPLATE_TEST_SET,
		ZSTRING_TOKEN_TABLE_TEST_SET
	]
		-- Test sets that do not yet have an evaluator
		do
			create Result
		end

	evaluator_type: TUPLE [CHAIN_TEST_EVALUATOR]
		do
			create Result
		end

	evaluator_types_all: TUPLE [
		CHAIN_TEST_EVALUATOR,
		DATE_TEXT_TEST_EVALUATOR,
		FILE_AND_DIRECTORY_TEST_EVALUATOR,
		GENERAL_TEST_EVALUATOR,
		STRING_LIST_TEST_EVALUATOR,
		SUBSTITUTION_TEMPLATE_TEST_EVALUATOR,
		TEMPLATE_TEST_EVALUATOR,
		URI_ENCODING_TEST_EVALUATOR,
		ZSTRING_TEST_EVALUATOR -- Incomplete test list
	]
		do
			create Result
		end

	visible_types: TUPLE [STRING_LIST_TEST_SET, URI_ENCODING_TEST_SET]
		do
			create Result
		end

end
