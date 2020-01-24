note
	description: "String list test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-24 13:16:53 GMT (Friday 24th January 2020)"
	revision: "1"

class
	STRING_LIST_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [STRING_LIST_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("split_string_8",			agent item.test_split_string_8)
			test ("split_and_join_1",		agent item.test_split_and_join_1)
			test ("split_and_join_2",		agent item.test_split_and_join_2)
			test ("path_split",				agent item.test_path_split)
			test ("occurrence_intervals", agent item.test_occurrence_intervals)
		end
end
