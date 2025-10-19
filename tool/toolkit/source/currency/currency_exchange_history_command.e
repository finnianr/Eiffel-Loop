note
	description: "[
		Compile CSV spreadsheet of historical currency exchange rates for multiple currencies
	]"
	notes: "[
		**Download HTML**
		
		In case of any problems with auto-download, manually download to this location:
		
			$HOME/.cache/Eiffel-Loop/toolkit/https
		
			https://www.exchangerates.org.uk/GBP-EUR-spot-exchange-rates-history-2023.html
			https://www.exchangerates.org.uk/USD-EUR-spot-exchange-rates-history-2023.html
			
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
	date: "2025-10-15 11:21:03 GMT (Wednesday 15th October 2025)"
	revision: "24"

class
	CURRENCY_EXCHANGE_HISTORY_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_FALLIBLE

	EL_STRING_GENERAL_ROUTINES_I

	EL_MODULE_EXCEPTION; EL_MODULE_FILE; EL_MODULE_LIO; EL_MODULE_TUPLE

	EL_SHARED_ENCODINGS

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

			create parsed_date.make_now
			create currency_code.make_empty
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
			csv_file: PLAIN_TEXT_FILE; i, i_final: INTEGER; date: EL_DATE
		do
			create date.make_now

			currency_list.sort (False)

			across currency_list as code until has_error loop
				currency_code := code.item
				column_index := code.cursor_index
				parse_html (Url_template #$ [code.item, base_currency, year])
			end
			if has_error then
				print_errors (lio)

			elseif attached exchange_rate_table as table then
				create csv_file.make_open_write (output_path)

				csv_file.put_string ("Column No.,2")
				across currency_list as code loop
					csv_file.put_character (',')
					csv_file.put_integer (code.cursor_index + 2)
				end
				csv_file.put_new_line

				csv_file.put_string ("," + base_currency + " (1)")
				across currency_list as code loop
					csv_file.put_character (',')
					csv_file.put_string (code.item + " to " + base_currency)
				end
				csv_file.put_new_line

				from table.start until table.after loop
					date.make_by_ordered_compact_date (table.item_key)
					csv_file.put_string (date.formatted_out (date_format))

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

	parse_html (history_url: ZSTRING)
		-- iterate over each HTML table row starting: "<tr id="
		local
			row_intervals: EL_OCCURRENCE_INTERVALS; start_index, end_index: INTEGER
			page_file: EL_CACHED_HTTP_FILE
		do
			lio.put_labeled_string ("Data source", history_url)
			lio.put_new_line
			create page_file.make (history_url, 10_000)

			lio.put_string ("Parsing ")
			previous_index := 0
			if attached File.plain_text (page_file.path) as html then
				create row_intervals.make_by_string (html, Table_row.open)
				if attached row_intervals as row then
					from row.start until row.after loop
						start_index := row.item_lower
						end_index := html.substring_index (Table_row.close, row.item_upper + 1)
						if end_index > 0 then
							parse_row (html.substring (start_index, end_index + 4))
						end
						row.forth
					end
				end
			end
			lio.put_line (" OK")
			lio.put_new_line
		end

	parse_row (row_html: STRING)
		-- Parse XML table row fragment as for example:

		--	<tr id="01-01-2024" class="colone">
		--		<td data-title="Date">Monday  1 January 2024</td>
		--		<td data-title="Closing Rate">&#163;1 GBP = &#8364;1.1534</td>
		--		<td data-title="Get link">GBP/EUR rate for 01/01/2024</td>
		-- </tr>
		require
			starts_with_tr: row_html.starts_with (Table_row.open)
			ends_with_tr_close: row_html.ends_with (Table_row.close)
		local
			xdoc: EL_XML_DOC_CONTEXT; rate_string: ZSTRING; parsed_rate: REAL
		do
			create xdoc.make_from_fragment (row_html, Encodings.Latin_1.code_page)
			parsed_date.make_with_format (xdoc [Xpath.id], Date_id_format)
			rate_string := xdoc @ Xpath.td_2_text
			parsed_rate := rate_string.substring_to_reversed (Euro_symbol).to_real

			exchange_rate_table.binary_search (parsed_date.ordered_compact_date)
			if exchange_rate_table.found then
				if exchange_rate_table.index \\ 20 = 0 then
					lio.put_character ('.')
				end
				if previous_index + 1 = exchange_rate_table.index then
					exchange_rate_table.item_value [column_index] := parsed_rate
					previous_index := exchange_rate_table.index
				else
					exchange_rate_table.go_i_th (previous_index + 1)
					Exception.raise_developer ("Missing day %S for %S", [exchange_rate_table.item_key, currency_code])
				end
			end
		end

feature {NONE} -- Internal attributes

	base_currency: STRING

	column_index: INTEGER

	currency_code: STRING

	currency_list: EL_STRING_8_LIST

	date_format: STRING

	exchange_rate_table: EL_KEY_INDEXED_ARRAYED_MAP_LIST [INTEGER, SPECIAL [REAL]]
		-- cannot use EL_HASH_TABLE because it lacks a routine `go_i_th (index)'

	output_path: FILE_PATH

	parsed_date: EL_DATE

	previous_index: INTEGER

	year: INTEGER

feature {NONE} -- Constants

	Date_id_format: STRING = "dd-mm-yyyy"
		-- id="31-01-2024"

	Euro_symbol: CHARACTER_32 = '€'

	Table_row: TUPLE [open, close: STRING]
		once
			create Result
			Tuple.fill (Result, "<tr id=,</tr>")
		end

	Url_template: ZSTRING
		once
			Result := "https://www.exchangerates.org.uk/%S-%S-spot-exchange-rates-history-%S.html"
		end

	Xpath: TUPLE [id, td_2_text: STRING]
		once
			create Result
			Tuple.fill (Result, "id, td [2]/text()")
		end

end