note
	description: "Summary description for {EL_MENU_APPLICATION_LAUNCHER_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:13:49 GMT (Monday 24th June 2013)"
	revision: "2"

deferred class
	EL_DESKTOP_APPLICATION_INSTALLER_I

inherit
	EL_PLATFORM_IMPL

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_STRING

	EL_MODULE_FILE_SYSTEM

feature {NONE} -- Initialization

	make (a_interface: like interface)
			--
		do
			interface := a_interface
		end

feature -- Access

	submenu_path: ARRAY [EL_DESKTOP_MENU_ITEM]
		do
			Result := interface.submenu_path
		end

	launcher: EL_DESKTOP_LAUNCHER
		-- launcher menu item
		do
			Result := interface.launcher
		end

	command_args_template: STRING
			--
		once
			Result := "-$sub_application_option $command_options"
		end

feature -- Basic operations

	install
			--
		deferred
		end

	uninstall
			--
		deferred
		end

feature -- Status query

	launcher_exists: BOOLEAN
			--
		deferred
		end

	has_desktop_launcher: BOOLEAN
		do
			Result := interface.has_desktop_launcher
		end

feature {NONE} -- Implementation

	interface: EL_DESKTOP_APPLICATION_INSTALLER

	Desktop_dir: EL_DIR_PATH
		once
			Result := Execution.User_profile_dir.joined_dir_path ({STRING_32} "Desktop")
		end

end
