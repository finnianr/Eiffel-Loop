note
	description: "Template test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-07 16:05:04 GMT (Tuesday 7th January 2020)"
	revision: "2"

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
