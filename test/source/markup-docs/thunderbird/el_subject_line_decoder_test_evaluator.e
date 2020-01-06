note
	description: "Subject line decoder test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-05 14:31:09 GMT (Sunday 5th January 2020)"
	revision: "1"

class
	EL_SUBJECT_LINE_DECODER_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [EL_SUBJECT_LINE_DECODER_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["iso",					agent item.test_iso],
				["utf_8",				agent item.test_utf_8]
			>>)
		end
end
