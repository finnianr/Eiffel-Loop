note
	description: "Date text test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-01 10:22:53 GMT (Friday 1st November 2019)"
	revision: "1"

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