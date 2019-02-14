note
	description: "Localization command shell test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-14 16:57:50 GMT (Thursday 14th February 2019)"
	revision: "1"

class
	LOCALIZATION_COMMAND_SHELL_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [LOCALIZATION_COMMAND_SHELL_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["add_unchecked",						agent item.test_add_unchecked]
			>>)
		end
end
