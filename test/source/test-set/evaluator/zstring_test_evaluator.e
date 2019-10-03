note
	description: "Zstring test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-02 10:01:19 GMT (Wednesday   2nd   October   2019)"
	revision: "4"

class
	ZSTRING_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [ZSTRING_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["joined", agent item.test_joined],
				["prepend_substring", agent item.test_prepend_substring],
				["append_substring", agent item.test_append_substring],
				["left_adjust", agent item.test_left_adjust],
				["xml_escape", agent item.test_xml_escape]
			>>)
		end

end
