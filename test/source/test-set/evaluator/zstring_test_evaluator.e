note
	description: "Zstring test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-12 13:28:59 GMT (Thursday 12th September 2019)"
	revision: "1"

class
	ZSTRING_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [ZSTRING_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["test_xml_escape", agent item.test_xml_escape]
			>>)
		end

end
