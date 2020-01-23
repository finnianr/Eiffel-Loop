note
	description: "Substitution template test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:58:30 GMT (Thursday 23rd January 2020)"
	revision: "1"

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
