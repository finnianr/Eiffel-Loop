note
	description: "Default EQA test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-31 14:11:43 GMT (Saturday 31st December 2022)"
	revision: "5"

class
	EL_DEFAULT_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO

feature {NONE} -- Implementation

	do_all (evaluator: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
		end
end