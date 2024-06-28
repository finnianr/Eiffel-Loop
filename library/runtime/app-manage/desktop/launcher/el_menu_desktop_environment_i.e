note
	description: "Setup application with a desktop menu"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-28 6:49:41 GMT (Friday 28th June 2024)"
	revision: "10"

deferred class
	EL_MENU_DESKTOP_ENVIRONMENT_I

inherit
	EL_DESKTOP_ENVIRONMENT_I
		redefine
			make
		end

feature {NONE} -- Initialization

	make (installable: EL_INSTALLABLE_APPLICATION)
			--
		do
			Precursor (installable)
			submenu_path := installable.desktop_menu_path
			launcher := installable.desktop_launcher
			menu_name := launcher.name
		end

feature -- Access

	launcher: EL_DESKTOP_MENU_ITEM

	submenu_path: ARRAY [EL_DESKTOP_MENU_ITEM]

feature -- Basic operations

	install
			--
		do
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

	disable_desktop_launcher
		do
			has_desktop_launcher := False
		end

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

feature {NONE} -- Constants

	Command_args_template: STRING
		once
			Result := "-$sub_application_option $command_options"
		end

end