note
	description: "Evaluates tests in [$source OBJECT_BUILDER_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-10 15:07:03 GMT (Monday 10th February 2020)"
	revision: "1"

class
	OBJECT_BUILDER_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [OBJECT_BUILDER_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("buildable_from_node_scan",			agent item.test_buildable_from_node_scan)
			test ("smart_buildable_from_node_scan",	agent item.test_smart_buildable_from_node_scan)
		end

end
