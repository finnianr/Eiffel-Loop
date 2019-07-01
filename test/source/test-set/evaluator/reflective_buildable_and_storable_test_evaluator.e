note
	description: "Reflective buildable and storable as xml test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-12 12:49:37 GMT (Wednesday 12th June 2019)"
	revision: "2"

class
	REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["reflective_buildable_and_storable_as_xml", agent item.test_reflective_buildable_and_storable_as_xml],
				["read_write", 										agent item.test_read_write]
			>>)
		end

end