note
	description: "Evaluates tests in [$source PYXIS_TO_XML_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-03 10:12:10 GMT (Monday 3rd February 2020)"
	revision: "16"

class
	PYXIS_TO_XML_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [PYXIS_TO_XML_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("conversion",	agent item.test_conversion)
		end

end
