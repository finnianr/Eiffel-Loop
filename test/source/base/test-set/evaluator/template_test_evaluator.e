note
	description: "Evaluates tests in [$source TEMPLATE_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-30 20:20:38 GMT (Thursday 30th January 2020)"
	revision: "4"

class
	TEMPLATE_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [TEMPLATE_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("basic", agent item.test_basic)
			test ("date", 	agent item.test_date)
		end

end
