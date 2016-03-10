note
	description: "Install application with a desktop menu"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-02 10:30:17 GMT (Sunday 2nd March 2014)"
	revision: "3"

class
	EL_DESKTOP_APPLICATION_INSTALLER

inherit
	EL_APPLICATION_INSTALLER

	EL_CROSS_PLATFORM_ABS
		undefine
			default_create
		end

	EL_MODULE_STRING
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_application: EL_SUB_APPLICATION; a_submenu_path: like submenu_path; a_launcher: EL_DESKTOP_LAUNCHER)
			--
		do
			submenu_path := a_submenu_path
			launcher := a_launcher
			create_implementation
			default_create
			description := a_application.single_line_description
			command_option_name := a_application.option_name.as_string_8
			input_path_option_name := a_application.input_path_option_name
			menu_name := launcher.name
		end

feature -- Access

	launcher: EL_DESKTOP_LAUNCHER

	submenu_path: ARRAY [EL_DESKTOP_MENU_ITEM]

feature -- Basic operations

	install
			--
		do
			launcher.set_command (command)
			launcher.set_command_args (command_args)
			launcher.set_comment (description)
			if not launcher_exists then
				implementation.install
			end
		ensure then
			launcher_exists: launcher_exists
		end

	uninstall
			--
		do
			if launcher_exists then
				implementation.uninstall
			end
		ensure then
			menu_entry_no_longer_exists: not launcher_exists
		end

feature -- Status change

	enable_desktop_launcher
		do
			has_desktop_launcher := True
		end

feature -- Status query

	launcher_exists: BOOLEAN
			--
		do
			Result := implementation.launcher_exists
		end

	has_desktop_launcher: BOOLEAN

feature {NONE} -- Implementation

	create_implementation
			--
		do
			create {EL_DESKTOP_APPLICATION_INSTALLER_IMPL} implementation.make (Current)
		end

	Command_args_template: STRING_32
			--
		do
			create Result.make_from_string (implementation.command_args_template)
			Result.left_adjust
			Result.prune ('%T')
			String.subst_all_characters (Result, '%N', ' ')
		end

	implementation: EL_DESKTOP_APPLICATION_INSTALLER_I

end
