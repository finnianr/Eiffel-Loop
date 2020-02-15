note
	description: "Default EQA test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 22:51:54 GMT (Friday 14th February 2020)"
	revision: "2"

class
	EL_DEFAULT_EQA_TEST_SET

inherit
	EL_EQA_TEST_SET

feature {NONE} -- Implementation

	do_all (evaluator: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
		end
end
