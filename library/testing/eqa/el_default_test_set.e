note
	description: "Default EQA test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-03 9:07:12 GMT (Monday 3rd October 2022)"
	revision: "3"

class
	EL_DEFAULT_TEST_SET

inherit
	EL_EQA_TEST_SET

feature {NONE} -- Implementation

	do_all (evaluator: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
		end
end