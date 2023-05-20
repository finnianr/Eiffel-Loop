note
	description: "Command line interface to [$source WEBSITE_MONITOR]"
	notes: "[
		Usage:
		
			el_toolkit -website_monitor -config <config-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-20 10:10:42 GMT (Saturday 20th May 2023)"
	revision: "30"

class
	WEBSITE_MONITOR_APP

inherit
	EL_COMMAND_LINE_APPLICATION [WEBSITE_MONITOR]
		undefine
			is_valid_platform
		end

	EL_UNIX_APPLICATION

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := << config_argument (Void)	>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end