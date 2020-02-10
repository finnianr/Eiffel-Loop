note
	description: "Evaluates tests in [$source SUBSTITUTION_TEMPLATE_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-30 20:20:51 GMT (Thursday 30th January 2020)"
	revision: "2"

class
	SUBSTITUTION_TEMPLATE_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [SUBSTITUTION_TEMPLATE_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("string_substitution",			agent item.test_string_substitution)
			test ("zstring_substitution",			agent item.test_zstring_substitution)
			test ("object_field_substitution",	agent item.test_object_field_substitution)
		end
end
