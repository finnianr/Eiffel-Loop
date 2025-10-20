note
	description: "Tests for library [./library/currency.html currency.ecf]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-10-20 17:23:50 GMT (Monday 20th October 2025)"
	revision: "9"

class
	CURRENCY_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
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
				["currency_texts",						agent test_currency_texts],
				["locale_table",							agent test_locale_table],
				["currency_history_exchange_rates",	agent test_currency_history_exchange_rates]
			>>)
		end

feature -- Tests

	test_currency_history_exchange_rates
		-- CURRENCY_TEST_SET.currency_history_exchange_rates

		-- caches https://www.exchangerates.org.uk/USD-EUR-spot-exchange-rates-history-2024.html
		-- to $HOME/.cache/Eiffel-Loop/test/https
		-- Cloudfare prevents repeated curl requests to same URL.
		note
			testing: "[
				covers/{EL_EXCHANGE_RATE_HISTORY_GRID}.parse_html,
				covers/{EL_EXCHANGE_RATE_HISTORY_GRID}.parse_row,
				covers/{EL_EXCHANGE_RATE_HISTORY_GRID}.day_rate,
				covers/{EL_EXCHANGE_RATE_HISTORY_GRID}.to_day_row,
				covers/{EL_EXCHANGE_RATE_HISTORY_GRID}.export_to_csv
			]"
		local
			rate_grid: EL_EXCHANGE_RATE_HISTORY_GRID; currency_list: EL_STRING_8_LIST
			csv_path: FILE_PATH; high, low, rate: REAL; i_th_day, dec_31st: DATE; year: INTEGER
		do
			year := 2024
			create currency_list.make_from_tuple (["USD"])
			create rate_grid.make (year, "EUR", currency_list)
			assert ("leap year", rate_grid.day_count = 366)

			low := 500000

			create dec_31st.make (year, 12, 31)

			from create i_th_day.make (year, 1, 1) until i_th_day > dec_31st loop
				rate := rate_grid.day_rate ("USD", i_th_day)
				high := high.max (rate); low := low.min (rate)
				i_th_day.day_forth
			end
			assert ("expected range", (high * 10_000).rounded = 9662 and (low * 10_000).rounded = 8922)

			csv_path := Work_area_dir + "history.csv"
			rate_grid.export_to_csv (csv_path, "[0]dd/[0]mm/yyyy")
			assert_same_digest (Plain_text, csv_path, "iJJr7CnvmyshGUPNQvkM5Q==")
		end

	test_currency_texts
		-- CURRENCY_TEST_SET.currency_texts
		note
			testing: "[
				covers/{EL_CURRENCY_TEXTS}.name,
				covers/{EL_ROUTINE_LOG}.put_columns
			]"
		do
			do_test ("display_currency_names", 4277035604, agent display_currency_names, [])
		end

	test_locale_table
		-- CURRENCY_TEST_SET.locale_table
		note
			testing: "[
				covers/{EL_LOCALIZED_CURRENCY_TABLE}.item,
				covers/{EL_FUNCTION_CACHE_TABLE}.item
			]"
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
				lio.put_columns (name_list, column_count, 0)
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