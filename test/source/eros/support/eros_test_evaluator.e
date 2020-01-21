note
	description: "Eros test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-21 14:55:02 GMT (Tuesday 21st January 2020)"
	revision: "2"

class
	EROS_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [EROS_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["fft",	 agent item.test_fft]
			>>)
		end
end
