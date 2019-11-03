note
	description: "Evaluator for class [$source TAG_INFO_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 10:54:10 GMT (Thursday 31st October 2019)"
	revision: "3"

class
	TAGLIB_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [TAGLIB_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
--				["read_basic_id3", 	agent item.test_read_basic_id3],
				["read_id3_frames", 	agent item.test_read_id3_frames]
			>>)
		end
end
