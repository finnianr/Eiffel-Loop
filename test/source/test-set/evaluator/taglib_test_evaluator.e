note
	description: "Evaluator for class [$source TAG_INFO_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 19:23:44 GMT (Monday 11th November 2019)"
	revision: "4"

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
