note
	description: "Tokenized string test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-15 13:40:03 GMT (Friday 15th January 2021)"
	revision: "8"

class
	ZSTRING_TOKEN_TABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_TEST_STRINGS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("tokens", agent test_tokens)
		end

feature -- Tests

	test_tokens
		local
			table: EL_ZSTRING_TOKEN_TABLE
			line: ZSTRING; path_tokens: STRING_32
		do
			across text_lines as list loop
				line := list.item
				create table.make (30)
				path_tokens := table.token_list (line, ' ')
				assert ("same token list", path_tokens ~ table.iterable_to_token_list (line.split (' ')))
			end
		end

end