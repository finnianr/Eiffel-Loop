note
	description: "Tests for library [./library/currency.html currency.ecf]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-17 9:56:32 GMT (Monday 17th February 2025)"
	revision: "6"

class
	CURRENCY_TEST_SET

inherit
	EL_EQA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_SHARED_LOCALIZED_CURRENCY_TABLE

	EL_SHARED_CURRENCY_ENUM

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["currency_texts",  agent test_currency_texts],
				["locale_table",	  agent test_locale_table]
			>>)
		end

feature -- Tests

	test_currency_texts
		-- CURRENCY_TEST_SET.test_currency_texts
		note
			testing: "[
				covers/{EL_CURRENCY_TEXTS}.name,
				covers/{EL_ROUTINE_LOG}.put_columns
			]"
		do
			do_test ("display_currency_names", 4277035604, agent display_currency_names, [])
		end

	test_locale_table
		note
			testing: "covers/{EL_LOCALIZED_CURRENCY_TABLE}.item, covers/{EL_FUNCTION_CACHE_TABLE}.item"
		local
			c1, c2: EL_CURRENCY
		do
			c1 := Currency_table.item ("en", Currency_enum.eur)
			c2 := Currency_table.item ("en", Currency_enum.eur)
			assert ("same instance", c1 = c2)
		end

feature {NONE} -- Implementation

	display_currency_names
		local
			name_list: EL_ARRAYED_RESULT_LIST [NATURAL_8, ZSTRING]
			column_count: INTEGER
		do
			create name_list.make (Currency_enum.as_list, agent new_name)
			from column_count := 3 until column_count > 5 loop
				lio.put_integer_field ("Columns", column_count)
				lio.put_new_line
				lio.put_columns (name_list, column_count)
				lio.put_new_line
				column_count := column_count + 1
			end
		end

	new_name (code: NATURAL_8): ZSTRING
		local
			currency: EL_CURRENCY
		do
			create currency.make ("en", code)
			Result := currency.name
		end
end