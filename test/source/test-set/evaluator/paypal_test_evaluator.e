note
	description: "Paypal test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-02 10:46:09 GMT (Wednesday   2nd   October   2019)"
	revision: "1"

class
	PAYPAL_TEST_EVALUATOR
inherit
	EL_EQA_TEST_SET_EVALUATOR [PAYPAL_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["pp_transaction", agent item.test_pp_transaction]
			>>)
		end

end
