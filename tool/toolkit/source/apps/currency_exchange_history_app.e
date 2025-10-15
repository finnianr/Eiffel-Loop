note
	description: "[
		Command line interface to ${CURRENCY_EXCHANGE_HISTORY_COMMAND}
	]"
	notes: "[
		Usage:
			
			el_toolkit -currency_exchange_history -output <file-path> -year <year> -base <base-currency> -currencies <c1, c2 ..>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-10-15 10:44:27 GMT (Wednesday 15th October 2025)"
	revision: "22"

class
	CURRENCY_EXCHANGE_HISTORY_APP

inherit
	EL_COMMAND_LINE_APPLICATION [CURRENCY_EXCHANGE_HISTORY_COMMAND]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("output", "Path to CSV output file", No_checks),
				optional_argument ("year", "Historical year", No_checks),
				optional_argument ("base", "Base currency", No_checks),
				optional_argument ("date_format", "Format for output of dates", No_checks),
				required_argument ("currencies", "List of currencies", << valid_currency_code >>)
			>>
		end

	is_valid_code (code: STRING): BOOLEAN
		do
			if code.count = 3 then
				Result := across code as c all c.item.is_upper end
			end
		end

	default_make: PROCEDURE [like command]
		local
			date: DATE
		do
			create date.make_now
			Result := agent {like command}.make (
				create {FILE_PATH}, date.year - 1, "EUR", "dd/mm/yyyy", create {EL_STRING_8_LIST}.make_empty
			)
		end

	valid_currency_code: like No_checks.item
		do
			Result := ["Code %"%S%" should be 3 upper case letters", agent is_valid_code]
		end

end