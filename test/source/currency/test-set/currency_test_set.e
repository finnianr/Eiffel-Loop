note
	description: "Tests for library [./library/currency.html currency.ecf]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-04 11:33:08 GMT (Monday 4th October 2021)"
	revision: "1"

class
	CURRENCY_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_SHARED_LOCALIZED_CURRENCY_TABLE

	EL_SHARED_CURRENCY_ENUM

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("locale_table", agent test_locale_table)
		end

feature -- Tests

	test_locale_table
		note
			testing: "covers/{EL_LOCALIZED_CURRENCY_TABLE}.item", "covers/{EL_FUNCTION_CACHE_TABLE}.item"
		local
			c1, c2: EL_CURRENCY
		do
			c1 := Currency_table.item ("en", Currency_enum.eur)
			c2 := Currency_table.item ("en", Currency_enum.eur)
			assert ("same instance", c1 = c2)
		end

end