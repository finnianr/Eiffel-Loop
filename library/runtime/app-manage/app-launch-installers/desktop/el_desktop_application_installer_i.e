note
	description: "Install application with a desktop menu"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-15 17:25:26 GMT (Sunday 15th May 2016)"
	revision: "1"

deferred class
	EL_DESKTOP_APPLICATION_INSTALLER_I

inherit
	EL_APPLICATION_INSTALLER_I

feature {NONE} -- Initialization

	make (a_application: EL_SUB_APPLICATION; a_submenu_path: like submenu_path; a_launcher: EL_DESKTOP_LAUNCHER)
			--
		do
			make_default
			submenu_path := a_submenu_path; launcher := a_launcher
			description := a_application.single_line_description
			command_option_name := a_application.option_name
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
			launcher.set_command (launch_command)
			launcher.set_command_args (command_args)
			launcher.set_comment (description)
			if not launcher_exists then
				add_menu_entry
			end
		ensure then
			launcher_exists: launcher_exists
		end

	uninstall
			--
		do
			if launcher_exists then
				remove_menu_entry
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
		deferred
		end

	has_desktop_launcher: BOOLEAN

feature {NONE} -- Implementation

	add_menu_entry
		deferred
		end

	remove_menu_entry
		deferred
		end

	command_args_template: ZSTRING
			--
		do
			create Result.make_from_unicode (new_command_args_template)
			Result.left_adjust
			Result.prune ('%T')
			Result.replace_character ('%N', ' ')
		end

feature {NONE} -- Implementation

	new_command_args_template: ZSTRING
		do
			Result := "-$sub_application_option $command_options"
		end

end