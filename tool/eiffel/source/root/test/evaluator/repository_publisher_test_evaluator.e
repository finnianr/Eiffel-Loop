note
	description: "Repository publisher test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-07 10:49:37 GMT (Wednesday 7th August 2019)"
	revision: "2"

class
	REPOSITORY_PUBLISHER_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [REPOSITORY_PUBLISHER_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["test_publisher", 				agent item.test_publisher]
			>>)
		end
end
