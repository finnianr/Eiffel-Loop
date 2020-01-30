note
	description: "Evaluates tests in [$source URI_ENCODING_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-30 20:20:25 GMT (Thursday 30th January 2020)"
	revision: "1"

class
	URI_ENCODING_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [URI_ENCODING_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("url_query_hash_table",	agent item.test_url_query_hash_table)
		end
end
