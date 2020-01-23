note
	description: "Evaluator for class [$source ID3_TAG_INFO_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:58:48 GMT (Thursday 23rd January 2020)"
	revision: "6"

class
	ID3_TAG_INFO_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [ID3_TAG_INFO_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
--			test ("libid3_info", 	agent item.test_libid3_info)
			test ("underbit_id3_info", agent item.test_underbit_id3_info)
		end

end
