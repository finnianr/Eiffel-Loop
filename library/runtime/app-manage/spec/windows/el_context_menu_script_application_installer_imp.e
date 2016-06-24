note
	description: "Windows implementation of `EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 10:01:52 GMT (Friday 24th June 2016)"
	revision: "3"

class
	EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_IMP

inherit
	EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_I

	EL_APPLICATION_INSTALLER_IMP
		rename
			command_args_template as launch_script_template,
			command_args as script_args
		undefine
			application_command, getter_function_table
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

feature {EL_APPLICATION_INSTALLER_I} -- Constants

	Launch_script_location: EL_DIR_PATH
		once
			create Result
		end

	Launch_script_template: STRING =
		-- Substitution template

	"[
	]"


end
