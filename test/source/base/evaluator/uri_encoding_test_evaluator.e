note
	description: "Evaluates tests in [$source URI_ENCODING_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 17:41:42 GMT (Friday 31st January 2020)"
	revision: "2"

class
	URI_ENCODING_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [URI_ENCODING_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("utf_8_sequence",			agent item.test_utf_8_sequence)
			test ("url_query_hash_table",	agent item.test_url_query_hash_table)
		end

end
