note
	description: "Sub-application to call tests in descendants of `EQA_TEST_SET'"
	instructions: "Command option: `-base_autotest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-26 14:48:00 GMT (Sunday 26th January 2020)"
	revision: "67"

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

		DIGEST_ROUTINES_TEST_SET, DIR_URI_PATH_TEST_SET,
		GENERAL_TEST_SET,
		PATH_TEST_SET, PATH_STEPS_TEST_SET,
		REFLECTION_TEST_SET,
		STRING_EDITION_HISTORY_TEST_SET, STRING_EDITOR_TEST_SET,
		SE_ARRAY2_TEST_SET, STRING_32_ROUTINES_TEST_SET,
		TEMPLATE_TEST_SET,
		URI_ENCODING_TEST_SET,
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
		STRING_LIST_TEST_EVALUATOR,
		SUBSTITUTION_TEMPLATE_TEST_EVALUATOR,
		TEMPLATE_TEST_EVALUATOR,
		ZSTRING_TEST_EVALUATOR -- Incomplete test list
	]
		do
			create Result
		end

	visible_types: TUPLE [STRING_LIST_TEST_SET]
		do
			create Result
		end

end
