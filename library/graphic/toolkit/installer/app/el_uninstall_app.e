note
	description: "Uninstall sub-application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-08 7:54:07 GMT (Sunday 8th September 2024)"
	revision: "7"

deferred class
	EL_UNINSTALL_APP [PIXMAPS -> EL_STOCK_PIXMAPS create make end]

inherit
	EL_STANDARD_UNINSTALL_APP
		export
			{EL_MODELED_DIALOG} Text, do_uninstall
		undefine
			Desktop_menu_path
		redefine
			initialize, run, Desktop
		end

	EL_INSTALLABLE_APPLICATION
		undefine
			name
		end

feature {NONE} -- Initialization

	initialize
			--
		do
			create gui.make (False)
			new_confirm_dialog.show
		end

feature -- Basic operations

	run
		do
			exit_code := 1 -- uninstall script cancelled by default
			gui.launch
		end

feature {EL_MODELED_DIALOG} -- Implementation

	new_confirm_dialog: EL_UNINSTALL_DIALOG
		do
			create Result.make (Current)
		end

feature {NONE} -- Internal attributes

	gui: EL_VISION_2_APPLICATION [PIXMAPS]

feature {NONE} -- Installer constants

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			create {EL_UNINSTALL_APP_MENU_DESKTOP_ENV_IMP} Result.make (Current)
			Result.set_command_line_options (<< Standard_option.silent >>)
		end

end