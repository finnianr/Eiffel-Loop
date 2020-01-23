note
	description: "Zstring test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:57:50 GMT (Thursday 23rd January 2020)"
	revision: "6"

class
	ZSTRING_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [ZSTRING_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("joined", 				agent item.test_joined)
			test ("prepend_substring",	agent item.test_prepend_substring)
			test ("append_substring",	agent item.test_append_substring)
			test ("left_adjust",			agent item.test_left_adjust)
			test ("xml_escape",			agent item.test_xml_escape)
		end

end
