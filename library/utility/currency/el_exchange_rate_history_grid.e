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
	date: "2026-11-20 17:22:02 GMT (Friday 20th October 2026)"
	revision: "6"

class
	EL_EXCHANGE_RATE_HISTORY_GRID

inherit
	ARRAY2 [REAL]
		rename
			height as day_count,
			make as make_grid,
			put as put_rate,
			item as rate_item alias "[]"
		export
			{NONE} all
			{ANY} rate_item, day_count, width
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

	make (a_output_path: FILE_PATH; a_year: INTEGER; a_base_currency: STRING; a_currency_list: EL_STRING_8_LIST)
		local
			i_th_day, dec_31st: EL_DATE; r: REAL; year_day_count: INTEGER
			html_path: FILE_PATH; history_url, base_name: ZSTRING; html_path_list: EL_FILE_PATH_LIST
		do
			make_lio
			output_path := a_output_path; year := a_year; base_currency := a_base_currency
			currency_list := a_currency_list
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
			create html_path_list.make (currency_list.count)
			across currency_list as currency_code until has_error loop
				history_url := Url_template #$ [currency_code, base_currency, year]
				base_name := history_url.substring_to_reversed ('/')
				html_path := output_path.parent + base_name
				if html_path.exists then
					html_path_list.extend (html_path)
				else
					lio.put_labeled_string ("Download", history_url)
					lio.put_new_line
					lio.put_spaces (6)
					lio.put_labeled_string ("to", html_path)
					lio.put_new_line_x2
				end
			end
			if currency_list.count = html_path_list.count then
				across currency_list as code until has_error loop
					html_path := html_path_list [@ code.cursor_index]
					parse_html (html_path, @ code.cursor_index + 1, code)
				end
			else
				put_error_message ("Missing download files")
			end
		ensure
			valid_column_count: width = currency_list.count + 1
			day_of_year_table_filled: day_of_year_table.count = day_count
		end

feature -- Access

	base_currency: STRING

	day_rate (currency_code: STRING; date: DATE): REAL
		require
			valid_currency: has_currency (currency_code)
		local
			column, row: INTEGER
		do
			column := currency_list.index_of (currency_code, 1)
			row := to_day_row (date)
			if row > 0 and column > 0 then
				Result := rate_item (row, column + 1)
			end
		end

	year: INTEGER

	output_path: FILE_PATH

feature -- Status query

	has_currency (code: STRING): BOOLEAN
		do
			Result := currency_list.has (code)
		end

feature -- Conversion

	to_day_row (date: DATE): INTEGER
		require
			valid_year: date.year = year
		do
			Result := day_of_year_table [date.ordered_compact_date]
		end

feature -- Basic operations

	export_to_csv (date_format: STRING)
		-- export to `output_path' as comma separated values with dates formatted as `date_format'
		local
			csv_file: PLAIN_TEXT_FILE; column: INTEGER; date: EL_DATE
		do
			create date.make_now
			create csv_file.make_open_write (output_path)

			csv_file.put_string ("Column No.,2")
			across currency_list as code loop
				csv_file.put_character (',')
				csv_file.put_integer (@ code.cursor_index + 2)
			end
			csv_file.put_new_line

			csv_file.put_string ("," + base_currency + " (1)")
			across currency_list as code loop
				csv_file.put_character (',')
				csv_file.put_string (code + " to " + base_currency)
			end
			csv_file.put_new_line

			across day_of_year_table as day_row loop
				date.make_by_ordered_compact_date (@ day_row.key)
				csv_file.put_string (date.formatted_out (date_format))

				from column := 1 until column > width loop
					csv_file.put_character (',')
					csv_file.put_real (rate_item (day_row, column))
					column := column + 1
				end
				csv_file.put_new_line
			end
			csv_file.close
		end

feature {NONE} -- Implementation

	adjust_html (row_html: STRING)
		-- Edit bad attribute: <tr..  hidden aria-hidden="true">
		do
			if year >= 2025 then
				row_html.replace_substring_all ("hidden aria-hidden", "hidden")
			end
		end

	encoding_name: STRING
		do
			if year >= 2025 then
				Result := Encodings.Utf_8.code_page
			else
				Result := Encodings.Latin_1.code_page
			end
		end

	parsed_rate (xdoc: EL_XML_DOC_CONTEXT): REAL
		local
			rate_string_2024: ZSTRING; rate_string_2025: STRING
		do
			inspect year
				when 2024 then
				--	<tr id="01-01-2024" class="colone">
				--		<td data-title="Date">Monday  1 January 2024</td>
				--		<td data-title="Closing Rate">&#163;1 GBP = &#8364;1.1534</td>
				--		<td data-title="Get link">GBP/EUR rate for 01/01/2024</td>
				-- </tr>
					rate_string_2024 := xdoc @ Xpath.td_2_text
					Result := rate_string_2024.substring_to_reversed (Euro_symbol).to_real

				when 2025 then
				--	<tr id="03-10-2025" data-history-date="2025-10-03"	data-history-saturday="0"class="erukHistDateRow">
				--		<td>
				--			<time datetime="2025-10-03">
				--			<span class="erukHistDateDesktopText">Fri 3 Oct 2025</span>
				--			<span class="erukHistDateMobileText">Fri 03/10/2025</span></time>
				--		</td>
				--		<td>0.8529</td>
				--		<td><strong>1 USD = 0.8516 EUR</strong></td>
				--		<td>0.8502</td>
				--		<td>0.8535</td>
				--		<td>
				--			<span class="erukHistChange is-down">-0.15%</span>
				--		</td>
				--		<td class="erukHistMoreInfoText">USD/EUR rate for 03/10/2025</td>
				--	</tr>
				rate_string_2025 := xdoc @ Xpath.td_3_strong_text
				if attached rate_string_2025.split (' ') as parts and then parts.count = 5 then
					Result := parts [4].to_real_32
				end
			else
			end
		end

	parse_html (html_path: FILE_PATH; column_index: INTEGER; currency_code: STRING)
		-- iterate over each HTML table row for `currency_code' starting: "<tr id="
		local
			row_intervals: EL_OCCURRENCE_INTERVALS; start_index, end_index: INTEGER
		do
			lio.put_labeled_string ("Parsing", html_path.base)
			lio.put_new_line
			previous_day_row := 0
			if attached File.plain_text (html_path) as html then
				create row_intervals.make_by_string (html, Table_row.open)
				if attached row_intervals as row then
					from row.start until row.after or has_error loop
						start_index := row.item_lower
						end_index := html.substring_index (Table_row.close, row.item_upper + 1)
						if end_index > 0 and then attached html.substring (start_index, end_index + 4) as row_html then
							adjust_html (row_html)
							parse_row (column_index, currency_code, row_html)
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
		-- Parse XML for `year' table row fragment as for example:
		require
			starts_with_tr: row_html.starts_with (Table_row.open)
			ends_with_tr_close: row_html.ends_with (Table_row.close)
		local
			xdoc: EL_XML_DOC_CONTEXT; error: EL_ERROR_DESCRIPTION; day_row: INTEGER
		do
			create xdoc.make_from_fragment (row_html, encoding_name)
			if attached xdoc.last_exception as exception then
				put_error (exception.to_error)
				error_list.last.extend (row_html)
			else
				parsed_date.make_with_format (xdoc [Xpath.id], Date_id_format)

				day_row := to_day_row (parsed_date)
				if day_row > 0 then
					if day_row \\ 5 = 0 then
						lio.put_character ('.')
					end
					put_rate (parsed_rate (xdoc), day_row, column_index)
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

	Xpath: TUPLE [id, td_2_text, td_3_strong_text: STRING]
		once
			create Result
			Tuple.fill (Result, "id, td [2]/text(), td [3]/strong/text()")
		end

end
