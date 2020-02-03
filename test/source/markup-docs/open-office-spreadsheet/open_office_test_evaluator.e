note
	description: "Evaluates tests in [$source OPEN_OFFICE_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-03 10:17:00 GMT (Monday 3rd February 2020)"
	revision: "16"

class
	OPEN_OFFICE_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [OPEN_OFFICE_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("read_row_cells",	agent item.test_read_row_cells)
		end

end
