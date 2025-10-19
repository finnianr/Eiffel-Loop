note
	description: "[
		Compile CSV spreadsheet of currency exchange rates for one year for multiple currencies
		using data from UK site [https://www.exchangerates.org.uk].
		See class ${EL_EXCHANGE_RATE_HISTORY_TABLE} for details.
	]"
	notes: "[
		In case of any problems with auto-download, manually download to this location:

			$HOME/.cache/Eiffel-Loop/toolkit/https

			https://www.exchangerates.org.uk/GBP-EUR-spot-exchange-rates-history-2023.html
			https://www.exchangerates.org.uk/USD-EUR-spot-exchange-rates-history-2023.html
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-10-19 17:57:49 GMT (Sunday 19th October 2025)"
	revision: "25"

class
	CURRENCY_EXCHANGE_HISTORY_COMMAND

inherit
	EL_APPLICATION_COMMAND
		redefine
			error_check
		end

	EL_MODULE_LIO

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (
		a_output_path: FILE_PATH; a_date_format, base_currency: STRING; year: INTEGER
		currency_list: EL_STRING_8_LIST
	)
		do
			output_path := a_output_path; date_format := a_date_format
			create history_table.make (year, base_currency, currency_list)
		end

feature -- Constants

	Description: STRING = "Compile CSV spreadsheet of historical currency exchange rates"

feature -- Basic operations

	execute
		do
			lio.put_path_field ("Writing CSV %S", output_path)
			history_table.export_to_csv (output_path, date_format)
			lio.put_new_line
		end

	error_check (application: EL_FALLIBLE)
		-- check for parsing errors before execution
		do
			application.set_errors (history_table)
		end

feature {NONE} -- Internal attributes

	history_table: EL_EXCHANGE_RATE_HISTORY_TABLE

	date_format: STRING

	output_path: FILE_PATH

end