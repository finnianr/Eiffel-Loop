note
	description: "[
		Exchange rate history grid using data from UK site [https://www.exchangerates.org.uk].
		Grid consists of columns of currency rates for a given list of currencies relative to a
		base currency for one calender year. Each row is a day of the year.
	]"
	notes: "[
		**CSV Export Example**
		
			Column No.,2,3,4
			,EUR (1),USD to EUR,GBP to EUR
			20210101,1,0.8241,1.1268
			20210102,1,0.824,1.1267
			20210103,1,0.8163,1.117
			
		See routine `export_to_csv'

		**Application to LibreOffice Calc**

		The resulting CSV export file can be imported into LibreOffice Calc or other spreadsheet application
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
	date: "2025-10-20 14:47:49 GMT (Monday 20th October 2025)"
	revision: "4"

class
	EL_EXCHANGE_RATE_HISTORY_GRID

inherit
	ARRAY2 [REAL]
		rename
			height as day_count,
			make as make_grid,
			put as put_rate,
			item as rate
		export
			{NONE} all
			{ANY} rate, day_count, width
		end

	EL_FALLIBLE
		rename
			put as put_error
		export
			{NONE} all
		undefine
			copy, is_equal
		end

	EL_IO_LOGGABLE

	EL_MODULE_FILE; EL_MODULE_TUPLE

	EL_SHARED_ENCODINGS

	DATE_CONSTANTS
		export
			{NONE} all
		undefine
			copy, is_equal
		end

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_year: INTEGER; a_base_currency: STRING; a_currency_list: EL_STRING_8_LIST)
		local
			i_th_day, dec_31st: EL_DATE; r: REAL; year_day_count: INTEGER
		do
			make_lio
			year := a_year; base_currency := a_base_currency; currency_list := a_currency_list
			year_day_count := if is_leap_year (year) then Days_in_leap_year else Days_in_non_leap_year end

			create parsed_date.make_now
			create dec_31st.make (a_year, 12, 31)

		-- Column 1 is reserved for `base_currency' which should be 1.0 for all days
			make_filled (r.zero, year_day_count, a_currency_list.count + 1)

			create day_of_year_table.make (day_count)

			from create i_th_day.make (a_year, 1, 1) until i_th_day > dec_31st loop
				day_of_year_table.extend (day_of_year_table.count + 1, i_th_day.ordered_compact_date)
				put_rate (r.one, day_of_year_table.count, 1)
				i_th_day.day_forth
			end

			currency_list.sort (False)
			across currency_list as code until has_error loop
				parse_html (code.cursor_index + 1, code.item)
			end
		ensure
			valid_column_count: width = currency_list.count + 1
			day_of_year_table_filled: day_of_year_table.count = day_count
		end

feature -- Access

	base_currency: STRING

	year: INTEGER

feature -- Conversion

	to_day_row (date: DATE): INTEGER
		require
			valid_year: date.year = year
		do
			Result := day_of_year_table [date.ordered_compact_date]
		end

feature -- Basic operations

	export_to_csv (output_path: FILE_PATH; date_format: STRING)
		-- export to `output_path' as comma separated values with dates formatted as `date_format'
		local
			csv_file: PLAIN_TEXT_FILE; column, day_row: INTEGER; date: EL_DATE
		do
			create date.make_now
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

			across day_of_year_table as table loop
				day_row := table.item
				date.make_by_ordered_compact_date (table.key)
				csv_file.put_string (date.formatted_out (date_format))

				from column := 1 until column > width loop
					csv_file.put_character (',')
					csv_file.put_real (rate (day_row, column))
					column := column + 1
				end
				csv_file.put_new_line
			end
			csv_file.close
		end

feature {NONE} -- Implementation

	parse_html (column_index: INTEGER; currency_code: STRING)
		-- iterate over each HTML table row for `currency_code' starting: "<tr id="
		local
			row_intervals: EL_OCCURRENCE_INTERVALS; start_index, end_index: INTEGER
			page_file: EL_CACHED_HTTP_FILE; history_url: ZSTRING
		do
			history_url := Url_template #$ [currency_code, base_currency, year]
			lio.put_labeled_string ("Data source", history_url)
			lio.put_new_line
			create page_file.make (history_url, 10_000)

			lio.put_string ("Parsing.")
			previous_day_row := 0
			if attached File.plain_text (page_file.path) as html then
				create row_intervals.make_by_string (html, Table_row.open)
				if attached row_intervals as row then
					from row.start until row.after or has_error loop
						start_index := row.item_lower
						end_index := html.substring_index (Table_row.close, row.item_upper + 1)
						if end_index > 0 then
							parse_row (column_index, currency_code, html.substring (start_index, end_index + 4))
						end
						row.forth
					end
				end
			end
			if not has_error then
				lio.put_line (" DONE")
				lio.put_new_line
			end
		end

	parse_row (column_index: INTEGER; currency_code, row_html: STRING)
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
			error: EL_ERROR_DESCRIPTION; day_row: INTEGER
		do
			create xdoc.make_from_fragment (row_html, Encodings.Latin_1.code_page)
			if attached xdoc.last_exception as exception then
				put_error (exception.to_error)
				error_list.last.extend (row_html)
			else
				parsed_date.make_with_format (xdoc [Xpath.id], Date_id_format)
				rate_string := xdoc @ Xpath.td_2_text
				parsed_rate := rate_string.substring_to_reversed (Euro_symbol).to_real

				day_row := to_day_row (parsed_date)
				if day_row > 0 then
					if day_row \\ 5 = 0 then
						lio.put_character ('.')
					end
					put_rate (parsed_rate, day_row, column_index)
					previous_day_row := day_row
				else
					create error.make_substituted ("Missing day %S for %S", [previous_day_row + 1, currency_code])
					put_error (error)
				end
			end
		end

feature {NONE} -- Internal attributes

	currency_list: EL_STRING_8_LIST

	day_of_year_table: HASH_TABLE [INTEGER, INTEGER]
		-- lookup day of year from `ordered_compact_date'

	parsed_date: EL_DATE

	previous_day_row: INTEGER

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