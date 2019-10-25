note
	description: "Evaluator for class [$source TAG_INFO_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-25 12:39:29 GMT (Friday   25th   October   2019)"
	revision: "2"

class
	TAG_INFO_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [TAG_INFO_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["read_id3", 	agent item.test_read_id3]
			>>)
		end
end
