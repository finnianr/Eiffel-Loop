note
	description: "[
		Command line interface to [$source HISTORICAL_CURRENCY_EXCHANGE_COMMAND]
	]"
	notes: "[
		Usage:
			
			el_toolkit -currency_exchange_history -year [year] -output [file-path] -currencies [c1, c2 ..]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-24 9:51:26 GMT (Thursday 24th November 2022)"
	revision: "15"

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
				required_argument ("currencies", "List of currencies", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, 2021, "EUR", create {EL_STRING_8_LIST}.make_empty)
		end

end
