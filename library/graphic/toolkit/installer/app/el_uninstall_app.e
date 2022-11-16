note
	description: "Uninstall sub-application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	EL_UNINSTALL_APP

inherit
	EL_STANDARD_UNINSTALL_APP
		export
			{EL_MODELED_DIALOG} Text
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

	do_uninstall
		do
			Application_list.uninstall
			exit_code := 0 -- uninstall script will continue to call directory delete script
		end

	new_confirm_dialog: EL_UNINSTALL_DIALOG
		do
			create Result.make (Current)
		end

feature {NONE} -- Internal attributes

	gui: EL_VISION_2_APPLICATION [EL_STOCK_PIXMAPS]

feature {NONE} -- Installer constants

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			create {EL_UNINSTALL_APP_MENU_DESKTOP_ENV_IMP} Result.make (Current)
			Result.set_command_line_options (<< Standard_option.silent >>)
		end

end