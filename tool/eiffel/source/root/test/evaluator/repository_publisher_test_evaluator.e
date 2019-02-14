note
	description: "Repository publisher test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-14 18:17:52 GMT (Thursday 14th February 2019)"
	revision: "1"

class
	REPOSITORY_PUBLISHER_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [REPOSITORY_PUBLISHER_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["regression", 				agent item.test_regression (957041218)]
			>>)
		end
end
