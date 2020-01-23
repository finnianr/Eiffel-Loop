note
	description: "Paypal test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:57:09 GMT (Thursday 23rd January 2020)"
	revision: "2"

class
	PAYPAL_TEST_EVALUATOR
inherit
	EL_EQA_TEST_SET_EVALUATOR [PAYPAL_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("pp_transaction", agent item.test_pp_transaction)
		end

end
