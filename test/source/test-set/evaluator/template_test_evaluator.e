note
	description: "Summary description for {TEMPLATE_TEST_EVALUATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEMPLATE_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [TEMPLATE_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["basic", 	agent item.test_basic],
				["date", 	agent item.test_date]
			>>)
		end

end
