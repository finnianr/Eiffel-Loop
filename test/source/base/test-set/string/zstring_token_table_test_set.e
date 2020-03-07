note
	description: "Tokenized string test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-07 12:40:21 GMT (Saturday 7th March 2020)"
	revision: "7"

class
	ZSTRING_TOKEN_TABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

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
			en_manual: ZSTRING; path_tokens: STRING_32
		do
			en_manual := "en/Manual"
			create table.make (3)
			path_tokens := table.token_list (en_manual, '/')
			assert ("same token list", path_tokens ~ table.iterable_to_token_list (<< "en", "Manual" >>))
		end

end
