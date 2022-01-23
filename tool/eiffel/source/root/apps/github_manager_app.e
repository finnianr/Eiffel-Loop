note
	description: "Command line interface to [$source GITHUB_MANAGER_SHELL_COMMAND]"
	notes: "[
		USAGE
			el_eiffel -github_manager -config <file-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 11:56:03 GMT (Sunday 23rd January 2022)"
	revision: "6"

class
	GITHUB_MANAGER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [GITHUB_MANAGER_SHELL_COMMAND]
		redefine
			visible_types
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("config", "Configuration file path", << file_must_exist >>),
				optional_argument ("define", "Define an environment variable: name=<value>", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, create {EL_DIR_PATH_ENVIRON_VARIABLE})
		end

	visible_types: TUPLE [GITHUB_MANAGER_SHELL_COMMAND, EL_BUILDABLE_AES_CREDENTIAL, EL_OS_COMMAND]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

end