note
	description: "[
		Command line interface to ${EL_SERVICE_MANAGER_SHELL} for managing
		services specified in a configuration file from a shell menu
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "6"

class
	EL_SERVICE_MANAGER_APP

inherit
	EL_COMMAND_SHELL_APPLICATION [EL_SERVICE_MANAGER_SHELL]
		redefine
			argument_list, command, default_make
		end

feature {NONE} -- Implementation

	argument_list: EL_ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		do
			Result := Precursor + config_argument (Void)
		end

	default_config_path: FILE_PATH
		do
			create Result
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent make_service_shell (?, default_menu_name, default_menu_rows, default_config_path)
		end

	make_service_shell (cmd: like command; name: READABLE_STRING_GENERAL; a_row_count: INTEGER; config_path: FILE_PATH)
		do
			cmd.make (name, a_row_count, config_path)
		end

feature {NONE} -- Internal attributes

	command: EL_SERVICE_MANAGER_SHELL

end