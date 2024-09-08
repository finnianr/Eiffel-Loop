note
	description: "Windows implementation of ${EL_FILE_CONTEXT_MENU_DESKTOP_ENV_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 12:08:02 GMT (Sunday 8th September 2024)"
	revision: "10"

class
	EL_FILE_CONTEXT_MENU_DESKTOP_ENV_IMP

inherit
	EL_FILE_CONTEXT_MENU_DESKTOP_ENV_I
		redefine
			install, uninstall
		end

	EL_DESKTOP_ENVIRONMENT_IMP
		rename
			make as make_installer,
			command_args_template as launch_script_template,
			command_args as script_args
		undefine
			application_command, make_default, getter_function_table
		redefine
			install, uninstall
		end

create
	make

feature -- Basic operations

	add_menu_entry
		do
		end

	install
		do
			Precursor {EL_FILE_CONTEXT_MENU_DESKTOP_ENV_I}
			Precursor {EL_DESKTOP_ENVIRONMENT_IMP} -- set Windows compatibility mode
		end

	remove_menu_entry
		do
		end

	uninstall
		do
			Precursor {EL_FILE_CONTEXT_MENU_DESKTOP_ENV_I}
			Precursor {EL_DESKTOP_ENVIRONMENT_IMP} -- remove Windows compatibility mode
		end

feature {EL_DESKTOP_ENVIRONMENT_I} -- Constants

	Launch_script_location: DIR_PATH
		once
			create Result
		end

	Launch_script_template: STRING = ""
		-- Substitution template

end