note
	description: "Sub-application to aid development of AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 14:39:17 GMT (Wednesday 8th January 2020)"
	revision: "61"

class
	BASE_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		CHAIN_TEST_SET,
		DIGEST_ROUTINES_TEST_SET, DIR_URI_PATH_TEST_SET,
		GENERAL_TEST_SET,
		PATH_TEST_SET, PATH_STEPS_TEST_SET,
		REFLECTION_TEST_SET,
		STRING_EDITION_HISTORY_TEST_SET, STRING_EDITOR_TEST_SET, SUBSTITUTION_TEMPLATE_TEST_SET,
		SE_ARRAY2_TEST_SET, STRING_32_ROUTINES_TEST_SET,
		TEMPLATE_TEST_SET,
		URI_ENCODING_TEST_SET,
		ZSTRING_TOKEN_TABLE_TEST_SET
	]
		do
			create Result
		end

	evaluator_type: TUPLE [DATE_TEXT_TEST_EVALUATOR]
		do
			create Result
		end

	evaluator_types_all: TUPLE [
		DATE_TEXT_TEST_EVALUATOR,
		FILE_AND_DIRECTORY_TEST_EVALUATOR,
		TEMPLATE_TEST_EVALUATOR,
		ZSTRING_TEST_EVALUATOR
	]
		do
			create Result
		end

end
