note
	description: "Installer application with Vision-2 GUI"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 11:47:32 GMT (Monday 5th December 2022)"
	revision: "8"

deferred class
	EL_INSTALLER_APP [W -> EL_INSTALLER_MAIN_WINDOW create make end]

inherit
	EL_STANDARD_INSTALLER_APP
		rename
			init_console as init_console_and_logging
		undefine
			do_application, help_requested, init_console_and_logging, io_put_header, new_lio, print_help,
			standard_options
		redefine
			Description, initialize, install_package
		end

	EL_LOGGED_APPLICATION
		rename
			App_directory_list as Root_owned_app_directory_list
		undefine
			option_name, visible_types
		end

	EL_APPLICATION_CONSTANTS

feature {NONE} -- Initialization

	initialize
		do
			if App_option.test then
				Directory.Application_installation.set_path (Directory.current_working #+ "workarea/install")
			end
			create gui.make (True)
		end

feature -- Basic operations

	install_package
		do
			gui.launch
		end

feature {NONE} -- Internal attributes

	gui: EL_VISION_2_USER_INTERFACE [W, EL_STOCK_PIXMAPS]

feature {NONE} -- Constants

	Description: ZSTRING
		once
			Result := "Installs " + Build_info.product + " application"
		end

end