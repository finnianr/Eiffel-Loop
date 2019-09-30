note
	description: "Zstring test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-30 5:40:49 GMT (Monday   30th   September   2019)"
	revision: "3"

class
	ZSTRING_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [ZSTRING_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["test_joined", agent item.test_joined],
				["test_prepend_substring", agent item.test_prepend_substring],
				["test_append_substring", agent item.test_append_substring],
				["test_left_adjust", agent item.test_left_adjust],
				["test_xml_escape", agent item.test_xml_escape]
			>>)
		end

end
