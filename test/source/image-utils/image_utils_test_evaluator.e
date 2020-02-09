note
	description: "Evaluates tests in [$source IMAGE_UTILS_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-08 10:09:05 GMT (Saturday 8th February 2020)"
	revision: "2"

class
	IMAGE_UTILS_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [IMAGE_UTILS_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("svg_to_png_conversion",	agent item.test_svg_to_png_conversion)
		end

end
