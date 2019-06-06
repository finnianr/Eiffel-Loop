note
	description: "Reflective buildable and storable as xml test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-06 9:39:59 GMT (Thursday 6th June 2019)"
	revision: "1"

class
	REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["store_and_build", 	agent item.test_store_and_build]
			>>)
		end

end
