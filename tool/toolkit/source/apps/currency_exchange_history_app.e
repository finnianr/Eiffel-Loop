note
	description: "[
		Command line interface to [$source HISTORICAL_CURRENCY_EXCHANGE_COMMAND]
	]"
	notes: "[
		Usage:
			
			el_toolkit -currency_exchange_history -currencies c1, c2 ..
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-23 17:26:02 GMT (Wednesday 23rd November 2022)"
	revision: "14"

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
				required_argument ("currencies", "List of currencies", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, 2021, create {EL_STRING_8_LIST}.make_empty)
		end

end