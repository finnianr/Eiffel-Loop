note
	description: "Command line interface to [$source STOCK_CONSUMPTION_CALCULATOR]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 12:00:20 GMT (Sunday 23rd January 2022)"
	revision: "2"

class
	STOCK_CONSUMPTION_CALCULATOR_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [STOCK_CONSUMPTION_CALCULATOR]

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