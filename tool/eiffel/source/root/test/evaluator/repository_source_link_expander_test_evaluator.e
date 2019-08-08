note
	description: "Repository source link expander test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-07 10:50:54 GMT (Wednesday 7th August 2019)"
	revision: "2"

class
	REPOSITORY_SOURCE_LINK_EXPANDER_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [REPOSITORY_SOURCE_LINK_EXPANDER_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["test_link_expander", 	agent item.test_link_expander]
			>>)
		end
end
