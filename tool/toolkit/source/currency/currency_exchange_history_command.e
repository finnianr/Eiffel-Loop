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
			
		**Why curl fails on repeated requests**
		
		According to ChatGTP, the page returned is a Cloudflare error page.

		A big inline script that sets window._cf_chl_opt (with cType: 'managed', cRay, __cf_chl_* tokens)
		and loads /cdn-cgi/challenge-platform/... this JS challenge must run in a real browser to set cookies
		before you’re allowed through. Plain curl can’t solve it.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-10-20 8:43:06 GMT (Monday 20th October 2025)"
	revision: "27"

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
			create rate_grid.make (year, base_currency, currency_list)
		end

feature -- Constants

	Description: STRING = "Compile CSV spreadsheet of historical currency exchange rates"

feature -- Basic operations

	execute
		do
			lio.put_path_field ("Writing CSV %S", output_path)
			rate_grid.export_to_csv (output_path, date_format)
			lio.put_new_line
		end

	error_check (application: EL_FALLIBLE)
		-- check for parsing errors before execution
		do
			application.set_errors (rate_grid)
		end

feature {NONE} -- Internal attributes

	rate_grid: EL_EXCHANGE_RATE_HISTORY_GRID

	date_format: STRING

	output_path: FILE_PATH

end