note
	description: "Command line interface to ${WEBSITE_MONITOR}"
	notes: "[
		Usage:
		
			el_toolkit -website_monitor -config <config-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-20 13:18:21 GMT (Wednesday 20th March 2024)"
	revision: "32"

class
	WEBSITE_MONITOR_APP

inherit
	EL_COMMAND_LINE_APPLICATION [WEBSITE_MONITOR]
		undefine
			ask_user_to_quit, is_valid_platform
		end

	EL_UNIX_APPLICATION

create
	make

feature {NONE} -- Implementation

	ask_user_to_quit: BOOLEAN
		do
			Result := True
		end

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := << config_argument (Void)	>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

end