note
	description: "[
		Command line interface to ${CURRENCY_EXCHANGE_HISTORY_COMMAND}
	]"
	notes: "[
		Usage:
			
			el_toolkit -currency_exchange_history -output <file-path> -base <base-currency>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-15 10:18:39 GMT (Friday 15th November 2024)"
	revision: "21"

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
				optional_argument ("date_format", "Format for output of dates", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, "dd/mm/yyyy")
		end

end