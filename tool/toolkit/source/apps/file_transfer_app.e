note
	description: "Command line interface to [$source FILE_TRANSFER_COMMAND]"
	notes: "[
		Usage:
			el_toolkit -file_transfer -config <config-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-26 13:49:22 GMT (Sunday 26th March 2023)"
	revision: "2"

class
	FILE_TRANSFER_APP

inherit
	EL_COMMAND_LINE_APPLICATION [FILE_TRANSFER_COMMAND]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := << config_argument (Void) >>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end