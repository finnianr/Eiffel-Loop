note
	description: "String list test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-26 12:28:15 GMT (Sunday 26th January 2020)"
	revision: "3"

class
	STRING_LIST_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [STRING_LIST_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("path_split",				agent item.test_path_split)
			test ("test_split_sort",		agent item.test_split_sort)
			test ("split_string_8",			agent item.test_split_string_8)
			test ("split_and_join_1",		agent item.test_split_and_join_1)
			test ("split_and_join_2",		agent item.test_split_and_join_2)
			test ("occurrence_intervals", agent item.test_occurrence_intervals)
		end
end