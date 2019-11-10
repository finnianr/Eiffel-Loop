note
	description: "Template test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-01 11:14:06 GMT (Friday 1st November 2019)"
	revision: "1"

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
