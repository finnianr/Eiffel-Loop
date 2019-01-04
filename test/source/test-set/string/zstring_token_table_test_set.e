note
	description: "Tokenized string test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-01 16:14:41 GMT (Tuesday 1st January 2019)"
	revision: "5"

class
	ZSTRING_TOKEN_TABLE_TEST_SET

inherit
	EQA_TEST_SET

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
