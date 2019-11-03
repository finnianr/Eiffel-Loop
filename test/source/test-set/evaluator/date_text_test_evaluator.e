note
	description: "Summary description for {DATE_TEXT_TEST_EVALUATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DATE_TEXT_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [DATE_TEXT_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["formatted_date",							agent item.test_formatted_date],
				["from_ISO_8601_formatted",				agent item.test_from_iso_8601_formatted],
				["from_canonical_iso_8601_formatted",	agent item.test_from_canonical_iso_8601_formatted]
			>>)
		end

end
