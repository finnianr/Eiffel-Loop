note
	description: "Sub-application that is installable as a system menu item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-27 17:42:13 GMT (Sunday 27th May 2018)"
	revision: "1"

deferred class
	EL_INSTALLABLE_SUB_APPLICATION

feature -- Access

	installer: EL_APPLICATION_INSTALLER_I
		deferred
		end

feature -- Basic operations

	install
		do
			installer.set_description (single_line_description)
			installer.set_command_option_name (option_name)
			installer.set_input_path_option_name (input_path_option_name)
			installer.install
		end

	uninstall
			--
		do
			installer.uninstall
		end

feature -- Status query

	is_main: BOOLEAN
			-- True if this the main (or principle) sub application in the whole set
			-- In Windows this will be the app listed in the Control Panel/Programs List
		do
			Result := False
		end

feature {NONE} -- Factory

	new_context_menu_installer (menu_path: ZSTRING): EL_APPLICATION_INSTALLER_I
		do
			create {EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_IMP} Result.make (menu_path)
		end

	new_launcher (a_name: ZSTRING; a_icon_path: EL_FILE_PATH): EL_DESKTOP_LAUNCHER
			--
		do
			create Result.make (a_name, "", a_icon_path)
		end

	new_menu_item (a_name, a_comment: ZSTRING; a_icon_path: EL_FILE_PATH): EL_DESKTOP_MENU_ITEM
			-- User defined submenu
		do
			create Result.make (a_name, a_comment, a_icon_path)
		end

feature {NONE} -- Implementation

	input_path_option_name: STRING
		deferred
		end

	option_name: READABLE_STRING_GENERAL
		deferred
		end

	single_line_description: ZSTRING
		deferred
		end

feature {NONE} -- Constants

	Default_installer: EL_DO_NOTHING_INSTALLER
		once
			create Result.make_default
		end

end
