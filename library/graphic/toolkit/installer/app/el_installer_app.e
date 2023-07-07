note
	description: "Installer application with Vision-2 GUI"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-07 10:01:18 GMT (Friday 7th July 2023)"
	revision: "9"

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
			Description, initialize, install_package, run
		end

	EL_LOGGED_APPLICATION
		rename
			App_directory_list as Root_owned_app_directory_list
		undefine
			option_name, visible_types
		end

	EL_MODULE_FILE

	EL_APPLICATION_CONSTANTS

feature {NONE} -- Initialization

	initialize
		do
			if App_option.test then
				Directory.Application_installation.set_path (Workarea_install_dir)
			end
			create gui.make (True)
		end

feature -- Basic operations

	install_package
		do
			gui.launch
		end

	run
		do
			Precursor
			if App_option.test then
				log.enter ("run")
				log.put_line ("INSTALLED TEST FILES")
				across OS.file_list (Workarea_install_dir, "*") as list loop
					if attached list.item.relative_path (Directory.current_working).to_string as path then
						lio.put_integer_field (path, File.byte_count (list.item))
						lio.put_new_line
					end
				end
				OS.delete_tree (Workarea_install_dir)
				log.exit
			end
		end

feature {NONE} -- Internal attributes

	gui: EL_VISION_2_USER_INTERFACE [W, EL_STOCK_PIXMAPS]

feature {NONE} -- Constants

	Description: ZSTRING
		once
			Result := "Installs " + Build_info.product + " application"
		end

	Workarea_install_dir: DIR_PATH
		once
			Result := Directory.current_working #+ "workarea/install"
		end

end