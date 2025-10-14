note
	description: "[
		Compile CSV spreadsheet of historical currency exchange rates for multiple currencies
	]"
	notes: "[
		**Download HTML**
		
		Manually download data into output folder from site ''exchangerates.org.uk'' as in example:
		
			https://www.exchangerates.org.uk/GBP-EUR-spot-exchange-rates-history-2023.html
			https://www.exchangerates.org.uk/USD-EUR-spot-exchange-rates-history-2023.html
			
		The second currency (EUR) in file name is the base currency. For some reason using
		the **curl** program will not work, you need to use a browser.
			
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
	date: "2025-10-14 12:31:48 GMT (Tuesday 14th October 2025)"
	revision: "21"

class
	CURRENCY_EXCHANGE_HISTORY_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_FALLIBLE

	EL_STRING_GENERAL_ROUTINES_I

	EL_MODULE_EXCEPTION; EL_MODULE_FILE; EL_MODULE_OS; EL_MODULE_LOG; EL_MODULE_TUPLE

	EL_SHARED_ENCODINGS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_output_path: FILE_PATH; a_date_format: STRING)
		local
			date, dec_30_th: EL_DATE; r: REAL; rate_array: SPECIAL [REAL]; year: INTEGER
		do
			output_path := a_output_path; date_format := a_date_format

			create parsed_date.make_now
			create currency_code.make_empty
			create base_currency.make_empty
			create exchange_rate_table.make (365)

			html_path_list := OS.file_list (output_path.parent, "*.html")
			if html_path_list.count > 0 and then attached html_path_list.first_path as html_path then
				if attached html_path.base_name.to_string_8.split ('-') as parts and then parts.count > 3 then
					year := parts.last.to_integer
					base_currency := parts [2]
				end
				create dec_30_th.make (year, 12, 30)

				from create date.make (year, 1, 1) until date > dec_30_th loop
					create rate_array.make_filled (r.one, html_path_list.count + 1)
					exchange_rate_table.extend (date.ordered_compact_date, rate_array)
					date.day_forth
				end
				html_path_list.sort (False) -- USD before GBP
			else
				create exchange_rate_table.make_empty
				put_error_message (ZSTRING ("ERROR: no HTML exchange pages found in %S folder.") #$ [output_path.parent])
			end
		end

feature -- Constants

	Description: STRING = "Compile CSV spreadsheet of historical currency exchange rates"

feature -- Basic operations

	execute
		local
			csv_file: PLAIN_TEXT_FILE; i, i_final: INTEGER
		do
			across html_path_list as path until has_error loop
				currency_code := file_currency_code (path.item)
				column_index := path.cursor_index
				parse_html (path.item)
			end
			if has_error then
				print_errors (lio)

			elseif attached exchange_rate_table as table then
				create csv_file.make_open_write (output_path)

				csv_file.put_string ("Column No.,2")
				across html_path_list as list loop
					csv_file.put_character (',')
					csv_file.put_integer (list.cursor_index + 2)
				end
				csv_file.put_new_line

				csv_file.put_string ("," + base_currency + " (1)")
				across html_path_list as list loop
					csv_file.put_character (',')
					csv_file.put_string (file_currency_code (list.item) + " to " + base_currency)
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

	file_currency_code (html_path: FILE_PATH): STRING
		do
			Result := html_path.base_name.substring_to ('-')
		end

	formatted (compact_date: INTEGER): STRING
		do
			if attached Shared_date as date then
				date.make_by_ordered_compact_date (compact_date)
				Result := date.formatted_out (date_format)
			end
		end

	parse_row (row_html: STRING)
		-- Parse XML fragment as for example:
		
		--	<tr id="01-01-2024" class="colone">
		--		<td data-title="Date">Monday  1 January 2024</td>
		--		<td data-title="Closing Rate">&#163;1 GBP = &#8364;1.1534</td>
		--		<td data-title="Get link">GBP/EUR rate for 01/01/2024</td>
		-- </tr>
		local
			xdoc: EL_XML_DOC_CONTEXT; rate_string: ZSTRING
			parsed_rate: REAL
		do
			create xdoc.make_from_fragment (row_html, Encodings.Latin_1.code_page)
			parsed_date.make_with_format (xdoc [Xpath.id], Date_input_format)
			rate_string := xdoc @ Xpath.rate_text
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

	parse_html (html_path: FILE_PATH)
		-- iterate over each HTML table row starting: "<tr id="
		local
			row_intervals: EL_OCCURRENCE_INTERVALS; html: STRING
			start_index, end_index: INTEGER
		do
			lio.put_labeled_string ("Data source", html_path.base)
			lio.put_new_line
			lio.put_string ("Parsing ")
			previous_index := 0
			html := File.plain_text (html_path)
			create row_intervals.make_by_string (html, Table_row.open)
			if attached row_intervals as row then
				from row.start until row.after loop
					start_index := row.item_lower
					end_index := html.substring_index (Table_row.close, row.item_upper + 1)
					if end_index > 0 then
						end_index := end_index + Table_row.close.count - 1
						parse_row (html.substring (start_index, end_index))
					end
					row.forth
				end
			end
			lio.put_line (" OK")
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	base_currency: STRING

	column_index: INTEGER

	currency_code: STRING

	date_format: STRING

	exchange_rate_table: EL_KEY_INDEXED_ARRAYED_MAP_LIST [INTEGER, SPECIAL [REAL]]
		-- cannot use EL_HASH_TABLE because it lacks a routine `go_i_th (index)'

	html_path_list: EL_FILE_PATH_LIST

	output_path: FILE_PATH

	parsed_date: EL_DATE

	previous_index: INTEGER

feature {NONE} -- Constants

	Date_input_format: STRING = "dd-mm-yyyy"

	Euro_symbol: CHARACTER_32 = '€'

	Table_row: TUPLE [open, close: STRING]
		once
			create Result
			Tuple.fill (Result, "<tr id=,</tr>")
		end

	Xpath: TUPLE [id, rate_text: STRING]
		once
			create Result
			Tuple.fill (Result, "id, td [2]/text()")
		end

	Shared_date: EL_DATE
		once
			create Result.make_now
		end

end