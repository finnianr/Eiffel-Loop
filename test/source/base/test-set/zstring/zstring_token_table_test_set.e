note
	description: "${EL_ZSTRING_TOKEN_TABLE} test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-20 8:25:49 GMT (Friday 20th September 2024)"
	revision: "15"

class
	ZSTRING_TOKEN_TABLE_TEST_SET

inherit
	ZSTRING_EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["tokens", agent test_tokens]
			>>)
		end

feature -- Tests

	test_tokens
		local
			table: EL_ZSTRING_TOKEN_TABLE
			line: ZSTRING; path_tokens: STRING_32
		do
			across Text.lines_32 as list loop
				line := list.item
				create table.make (30)
				path_tokens := table.token_list (line, ' ')
				assert ("same token list", path_tokens ~ table.iterable_to_token_list (line.split_list (' ')))
			end
		end

end