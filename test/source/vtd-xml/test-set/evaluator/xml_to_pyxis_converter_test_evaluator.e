note
	description: "Evaluates tests in [$source XML_TO_PYXIS_CONVERTER_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 15:01:34 GMT (Thursday 6th February 2020)"
	revision: "1"

class
	XML_TO_PYXIS_CONVERTER_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [XML_TO_PYXIS_CONVERTER_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("conversions",	agent item.test_conversions)
		end

end
