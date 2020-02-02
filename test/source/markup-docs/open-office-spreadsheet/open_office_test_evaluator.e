note
	description: "Evaluates tests in [$source VTD_XML_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-02 9:29:02 GMT (Sunday 2nd February 2020)"
	revision: "15"

class
	OPEN_OFFICE_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [OPEN_OFFICE_TEST_SET]
		rename
			lio as log
		undefine
			new_lio, log
		end

	EL_MODULE_LOG
		select
			log
		end

feature {NONE} -- Implementation

	do_tests
		do
			test ("read_row_cells",	agent item.test_read_row_cells)
		end


end
