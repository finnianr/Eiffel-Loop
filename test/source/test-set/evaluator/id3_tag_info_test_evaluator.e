note
	description: "Evaluator for class [$source ID3_TAG_INFO_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-22 16:53:02 GMT (Sunday 22nd December 2019)"
	revision: "4"

class
	ID3_TAG_INFO_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [ID3_TAG_INFO_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
--				["libid3_info", 	agent item.test_libid3_info],
				["underbit_id3_info", agent item.test_underbit_id3_info]
			>>)
		end

end
