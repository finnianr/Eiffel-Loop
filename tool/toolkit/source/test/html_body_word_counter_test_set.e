note
	description: "Test class ${HTML_BODY_WORD_COUNTER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-14 17:52:20 GMT (Sunday 14th July 2024)"
	revision: "7"

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
			assert ("word count is 763", command.word_count = 763)
		end

end