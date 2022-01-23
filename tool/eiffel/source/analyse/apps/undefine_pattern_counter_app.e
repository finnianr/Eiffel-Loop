note
	description: "Command line interface to the command [$source UNDEFINE_PATTERN_COUNTER_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 11:56:06 GMT (Sunday 23rd January 2022)"
	revision: "10"

class
	UNDEFINE_PATTERN_COUNTER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [UNDEFINE_PATTERN_COUNTER_COMMAND]
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("sources", "Path to sources manifest file", << file_must_exist >>),
				optional_argument ("define", "Define an environment variable: name=<value>", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", create {EL_DIR_PATH_ENVIRON_VARIABLE})
		end

feature {NONE} -- Constants

	Option_name: STRING = "undefine_counter"

end