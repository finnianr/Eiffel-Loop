note
	description: "Test class [$source HTML_BODY_WORD_COUNTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 17:40:40 GMT (Friday 10th March 2023)"
	revision: "5"

class
	HTML_BODY_WORD_COUNTER_TEST_SET

inherit
	EL_EQA_TEST_SET

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["counter", agent test_counter]
			>>)
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