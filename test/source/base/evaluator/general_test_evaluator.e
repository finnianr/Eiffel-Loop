note
	description: "Evaluates tests in [$source GENERAL_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 17:08:17 GMT (Saturday 1st February 2020)"
	revision: "1"

class
	GENERAL_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [GENERAL_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("character_32_status_queries", 	agent item.test_character_32_status_queries)
			test ("any_array_numeric_type_dectection", 	agent item.test_any_array_numeric_type_detection)
		end
end
