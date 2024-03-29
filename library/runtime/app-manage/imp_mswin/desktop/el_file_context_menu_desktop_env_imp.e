note
	description: "Windows implementation of ${EL_FILE_CONTEXT_MENU_DESKTOP_ENV_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "9"

class
	EL_FILE_CONTEXT_MENU_DESKTOP_ENV_IMP

inherit
	EL_FILE_CONTEXT_MENU_DESKTOP_ENV_I

	EL_DESKTOP_ENVIRONMENT_IMP
		rename
			make as make_installer,
			command_args_template as launch_script_template,
			command_args as script_args
		undefine
			application_command, make_default, getter_function_table
		end

create
	make

feature -- Basic operations

	add_menu_entry
		do
		end

	remove_menu_entry
		do
		end

feature {EL_DESKTOP_ENVIRONMENT_I} -- Constants

	Launch_script_location: DIR_PATH
		once
			create Result
		end

	Launch_script_template: STRING = ""
		-- Substitution template


end