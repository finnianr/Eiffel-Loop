note
	description: "Summary description for {EL_MENU_APPLICATION_LAUNCHER_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-28 12:47:34 GMT (Sunday 28th June 2015)"
	revision: "4"

deferred class
	EL_DESKTOP_APPLICATION_INSTALLER_I

inherit
	EL_PLATFORM_IMPL
		rename
			make as make_default,
			set_interface as make
		export
			{NONE} make
		redefine
			interface
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

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

end
