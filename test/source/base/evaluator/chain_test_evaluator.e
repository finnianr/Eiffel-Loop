note
	description: "Evaluates tests in [$source CHAIN_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-25 16:20:13 GMT (Saturday 25th January 2020)"
	revision: "1"

class
	CHAIN_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [CHAIN_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("list_conversion",		agent item.test_list_conversion)
			test ("weight_summation_1", 	agent item.test_weight_summation_1)
			test ("weight_summation_2",	agent item.test_weight_summation_2)
			test ("weight_summation_3",	agent item.test_weight_summation_3)
			test ("string_list",				agent item.test_string_list)
			test ("mapping",					agent item.test_mapping)
			test ("order_by_color_name",	agent item.test_order_by_color_name)
			test ("order_by_weight",		agent item.test_order_by_weight)
			test ("find_predicate",			agent item.test_find_predicate)
		end
end
