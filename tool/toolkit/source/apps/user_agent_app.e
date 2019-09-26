note
	description: "Command line interface to class [$source USER_AGENT_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 15:26:22 GMT (Wednesday   25th   September   2019)"
	revision: "3"

class
	USER_AGENT_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [USER_AGENT_COMMAND]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("in", "Logfile path", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {EL_FILE_PATH})
		end

feature {NONE} -- Constants

	Description: STRING = "List all user agents in web server log file"

end
