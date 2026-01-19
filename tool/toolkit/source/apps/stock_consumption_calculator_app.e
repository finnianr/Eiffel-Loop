note
	description: "Command line interface to ${STOCK_CONSUMPTION_CALCULATOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	STOCK_CONSUMPTION_CALCULATOR_APP

inherit
	EL_COMMAND_LINE_APPLICATION [STOCK_CONSUMPTION_CALCULATOR]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("in", "Imported stock figures", << file_must_exist >>),
				optional_argument ("output", "Name of output file", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, create {FILE_PATH})
		end
end