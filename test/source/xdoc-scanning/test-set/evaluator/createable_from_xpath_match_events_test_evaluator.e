note
	description: "Evaluates tests in [$source CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-10 17:13:38 GMT (Monday 10th February 2020)"
	revision: "2"

class
	CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [CREATEABLE_FROM_XPATH_MATCH_EVENTS_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("match_events",	agent item.test_match_events)
		end

end
