note
	description: "Evaluates tests in [$source STRING_LIST_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 14:01:11 GMT (Saturday 1st February 2020)"
	revision: "5"

class
	STRING_LIST_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [STRING_LIST_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("split_and_join_3",		agent item.test_split_and_join_3)
			test ("fill_tuple",				agent item.test_fill_tuple)
			test ("path_split",				agent item.test_path_split)
			test ("test_split_sort",		agent item.test_split_sort)
			test ("split_string_8",			agent item.test_split_string_8)
			test ("split_and_join_1",		agent item.test_split_and_join_1)
			test ("split_and_join_2",		agent item.test_split_and_join_2)
			test ("occurrence_intervals", agent item.test_occurrence_intervals)
		end
end
