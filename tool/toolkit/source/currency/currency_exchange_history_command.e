note
	description: "Compile CSV spreadsheet of historical currency exchange rates for multiple currencies"
	notes: "[
		**Sample output**
		
			Column No.,2,3,4
			,EUR (1),USD to EUR,GBP to EUR
			20210101,1,0.8241,1.1268
			20210102,1,0.824,1.1267
			20210103,1,0.8163,1.117
			
		**Application to LibreOffice Calc**
		
		The resulting CSV file can be imported into LibreOffice Calc or other spreadsheet application
		and used to convert an amount to a target base currency based on historical exchange rate.
		
		Use an expression like the following to multiply by historical exchange rate based on date
		in column A, currency code in column D and amount to convert in column E
		
			=VLOOKUP($A1, exchange_table, INDIRECT($D1))*$E1
			
		This will work if you define a named range `exchange_table'. You also need to define the column number
		cells 2, 3, 4 etc, as single cell named ranges matching each of the currency codes.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-19 16:11:23 GMT (Sunday 19th November 2023)"
	revision: "17"

class
	CURRENCY_EXCHANGE_HISTORY_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_FALLIBLE
		redefine
			reset
		end

	EL_PARSER
		export
			{NONE} all
		redefine
			default_source_text, reset
		end

	TP_FACTORY

	EL_MODULE_EXCEPTION; EL_MODULE_FILE; EL_MODULE_LOG

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (
		a_output_path: FILE_PATH; a_year: INTEGER; a_base_currency, a_date_format: STRING
		a_currency_list: EL_STRING_8_LIST
	)
		local
			date, dec_30_th: EL_DATE; r: REAL; rate_array: SPECIAL [REAL]
		do
			output_path := a_output_path; year := a_year; base_currency := a_base_currency
			date_format := a_date_format; currency_list := a_currency_list

			make_default

			create parsed
			currency_code := Empty_string_8
			create exchange_rate_table.make (365)
			create dec_30_th.make (a_year, 12, 30)

			from create date.make (a_year, 1, 1) until date > dec_30_th loop
				create rate_array.make_filled (r.one, a_currency_list.count + 1)
				exchange_rate_table.extend (date.ordered_compact_date, rate_array)
				date.day_forth
			end
		end

feature -- Constants

	Description: STRING = "Compile CSV spreadsheet of historical currency exchange rates"

feature -- Basic operations

	execute
		local
			csv_file: PLAIN_TEXT_FILE; i, i_final: INTEGER
		do
			across currency_list as code until has_error loop
				currency_code := code.item
				column_index := code.cursor_index
				append_rates
			end
			if has_error then
				print_errors (lio)

			elseif attached exchange_rate_table as table then
				create csv_file.make_open_write (output_path)

				csv_file.put_string ("Column No.,2")
				across currency_list as list loop
					csv_file.put_character (',')
					csv_file.put_integer (list.cursor_index + 2)
				end
				csv_file.put_new_line

				csv_file.put_string ("," + base_currency + " (1)")
				across currency_list as list loop
					csv_file.put_character (',')
					csv_file.put_string (list.item + " to " + base_currency)
				end
				csv_file.put_new_line

				from table.start until table.after loop
					csv_file.put_string (formatted (table.item_key))

					i_final := table.item_value.count
					from i := 0 until i = i_final loop
						csv_file.put_character (',')
						csv_file.put_real (table.item_value [i])
						i := i + 1
					end
					csv_file.put_new_line
					table.forth
				end
				csv_file.close
			end
		end

feature {NONE} -- Implementation

	append_rates
		local
			page_file: EL_CACHED_HTTP_FILE
		do
			lio.put_labeled_string ("Data source", history_url)
			lio.put_new_line
			lio.put_string ("Parsing ")
			previous_index := 0
			create page_file.make (history_url, 10_000)
			reset_pattern
			set_source_text (File.plain_text (page_file.path))
			find_all (Void)
			lio.put_line (" OK")
			lio.put_new_line
		end

	default_source_text: STRING
		do
			Result := Empty_string_8
		end

	formatted (compact_date: INTEGER): STRING
		do
			if attached Shared_date as date then
				date.make_by_ordered_compact_date (compact_date)
				Result := date.formatted_out (date_format)
			end
		end

	history_url: ZSTRING
		do
			Result := Url_template #$ [currency_code, base_currency, year]
		end

	new_pattern: like all_of
		-- match string like: "USD = &#8364;0.8857</td><td><a href="/USD-EUR-15_12_2021"
		-- match string like: (02/01/2022)</td><td data-title="Closing Rate">&#36;1 USD = &#8364;0.8793</td>
		do
			Result := all_of (<<
			-- match "(02/01/2022)</td>"
				character_literal ('('),
				natural_number |to| agent on_day,
				character_literal ('/'),
				natural_number |to| agent on_month,
				character_literal ('/'),
				natural_number |to| agent on_year,
				string_literal (")</td>"),

			-- match anything up to " USD = &#8364;"
				while_not_p_match_any (
					all_of (<< string_literal (currency_code + " = &#"), natural_number, character_literal (';') >>)
				),
			-- match 0.8793
				decimal_constant |to| agent on_exchange_rate,
				string_literal ("</td>")
			>>)
			Result.set_action_last (agent on_entry_found)
		end

	parsed_date: INTEGER
		do
			if attached Shared_date as date then
				date.set_date (parsed.year, parsed.month, parsed.day)
				Result := date.ordered_compact_date
			end
		end

	reset
		do
			Precursor {EL_FALLIBLE}
			Precursor {EL_PARSER}
		end

feature {NONE} -- Event handlers

	on_day (start_index, end_index: INTEGER)
		do
			parsed.day := integer_32_substring (start_index, end_index)
		end

	on_entry_found (start_index, end_index: INTEGER)
		do
			exchange_rate_table.binary_search (parsed_date)
			if exchange_rate_table.found then
				if exchange_rate_table.index \\ 20 = 0 then
					lio.put_character ('.')
				end
				if previous_index + 1 = exchange_rate_table.index then
					exchange_rate_table.item_value [column_index] := parsed.rate
					previous_index := exchange_rate_table.index
				else
					exchange_rate_table.go_i_th (previous_index + 1)
					Exception.raise_developer ("Missing day %S for %S", [exchange_rate_table.item_key, currency_code])
				end
			end
		end

	on_exchange_rate (start_index, end_index: INTEGER)
		do
			parsed.rate := real_32_substring (start_index, end_index)
		end

	on_month (start_index, end_index: INTEGER)
		do
			parsed.month := integer_32_substring (start_index, end_index)
		end

	on_year (start_index, end_index: INTEGER)
		do
			parsed.year := integer_32_substring (start_index, end_index)
		end

feature {NONE} -- Internal attributes

	base_currency: STRING

	column_index: INTEGER

	currency_code: STRING

	currency_list: EL_STRING_8_LIST

	date_format: STRING

	exchange_rate_table: EL_KEY_INDEXED_ARRAYED_MAP_LIST [INTEGER, SPECIAL [REAL]]

	output_path: FILE_PATH

	parsed: TUPLE [rate: REAL; year, month, day: INTEGER]

	previous_index: INTEGER

	year: INTEGER

feature {NONE} -- Constants

	Delimiter: STRING = "</a></td></tr>"

	Link_suffix: STRING = "-exchange-rate-history"

	Shared_date: EL_DATE
		once
			create Result.make_now
		end

	Url_template: ZSTRING
		once
			Result := "https://www.exchangerates.org.uk/%S-%S-spot-exchange-rates-history-%S.html"
		end

end