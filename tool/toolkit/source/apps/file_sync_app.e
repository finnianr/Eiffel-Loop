note
	description: "Command line interface to [$source FILE_SYNC_COMMAND]"
	notes: "[
		Usage:
			el_toolkit -file_sync -config <config-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-09 15:00:25 GMT (Tuesday 9th May 2023)"
	revision: "3"

class
	FILE_SYNC_APP

inherit
	EL_COMMAND_LINE_APPLICATION [FILE_SYNC_COMMAND]

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