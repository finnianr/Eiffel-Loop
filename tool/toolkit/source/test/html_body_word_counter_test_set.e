note
	description: "Test class [$source HTML_BODY_WORD_COUNTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 9:40:44 GMT (Tuesday 4th October 2022)"
	revision: "3"

class
	HTML_BODY_WORD_COUNTER_TEST_SET

inherit
	EL_EQA_TEST_SET

	SHARED_DEV_ENVIRON

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("counter", agent test_counter)
		end

feature -- Tests

	test_counter
		local
			command: HTML_BODY_WORD_COUNTER
		do
			create command.make (Dev_environ.El_test_data_dir #+ "docs/html/I Ching")
			command.execute
			assert ("word count is 762", command.word_count = 819)
		end

end