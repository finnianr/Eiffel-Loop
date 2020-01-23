note
	description: "Repository source link expander test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 15:12:34 GMT (Thursday 23rd January 2020)"
	revision: "3"

class
	REPOSITORY_SOURCE_LINK_EXPANDER_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("test_link_expander", 	agent item.test_link_expander)
		end
end
