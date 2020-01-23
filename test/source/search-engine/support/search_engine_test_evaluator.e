note
	description: "Search engine test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:58:12 GMT (Thursday 23rd January 2020)"
	revision: "6"

class
	SEARCH_ENGINE_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [SEARCH_ENGINE_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("persistent_word_table", 	agent item.test_persistent_word_table)
		end
end
