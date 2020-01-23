note
	description: "Subject line decoder test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:57:13 GMT (Thursday 23rd January 2020)"
	revision: "2"

class
	EL_SUBJECT_LINE_DECODER_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [EL_SUBJECT_LINE_DECODER_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("iso",	agent item.test_iso)
			test ("utf_8",	agent item.test_utf_8)
		end
end
