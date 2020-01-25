note
	description: "Zstring test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-25 16:16:24 GMT (Saturday 25th January 2020)"
	revision: "7"

class
	ZSTRING_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [ZSTRING_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("prepend_substring",	agent item.test_prepend_substring)
			test ("joined", 				agent item.test_joined)
			test ("append_substring",	agent item.test_append_substring)
			test ("left_adjust",			agent item.test_left_adjust)
			test ("xml_escape",			agent item.test_xml_escape)
		end

end
