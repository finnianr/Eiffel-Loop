note
	description: "Evaluator for class [$source TAGLIB_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:57:04 GMT (Thursday 23rd January 2020)"
	revision: "7"

class
	TAGLIB_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [TAGLIB_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
--			test ("read_basic_id3", 	agent item.test_read_basic_id3)
			test ("read_id3_frames", 	agent item.test_read_id3_frames)
		end
end
