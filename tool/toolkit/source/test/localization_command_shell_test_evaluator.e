note
	description: "Localization command shell test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 15:11:26 GMT (Thursday 23rd January 2020)"
	revision: "2"

class
	LOCALIZATION_COMMAND_SHELL_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [LOCALIZATION_COMMAND_SHELL_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("add_unchecked",	agent item.test_add_unchecked)
		end
end
