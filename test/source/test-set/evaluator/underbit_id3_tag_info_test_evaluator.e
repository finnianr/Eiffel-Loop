note
	description: "Summary description for {UNDERBIT_ID3_TAG_INFO_TEST_EVALUATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	UNDERBIT_ID3_TAG_INFO_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [ID3_TAG_INFO_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["libid3_info", 	agent item.test_libid3_info],
				["underbit_id3_info", 	agent item.test_underbit_id3_info]
			>>)
		end

end
