note
	description: "Test class [$source HTML_BODY_WORD_COUNTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 4:53:41 GMT (Monday 7th February 2022)"
	revision: "2"

class
	HTML_BODY_WORD_COUNTER_TEST_SET

inherit
	EL_EQA_TEST_SET

	EIFFEL_LOOP_TEST_ROUTINES

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("counter", agent test_counter)
		end

feature -- Tests

	test_counter
		local
			command: HTML_BODY_WORD_COUNTER
		do
			create command.make (El_test_data_dir #+ "docs/html/I Ching")
			command.execute
			assert ("word count is 762", command.word_count = 819)
		end

end