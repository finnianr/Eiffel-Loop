note
	description: "Eros test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:57:39 GMT (Thursday 23rd January 2020)"
	revision: "3"

class
	EROS_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [EROS_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("fft", agent item.test_fft)
		end
end
