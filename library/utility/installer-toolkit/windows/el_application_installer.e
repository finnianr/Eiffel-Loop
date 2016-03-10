note
	description: "[
		Windows application installer
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:21 GMT (Tuesday 18th June 2013)"
	revision: "2"

deferred class
	EL_APPLICATION_INSTALLER

inherit
	EXECUTION_ENVIRONMENT
		rename
			current_working_directory as install_files_root
		export
			{NONE} all
		end

	EL_FILE_ROUTINES
		export
			{NONE} all
		end

	EL_LOGGING

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			create shell_link.make
		end

feature -- Access

	program_menu_path: EL_DIR_PATH

feature -- Element change

	 set_application_home (an_application_home: STRING)
			--
		do
			create application_home.make_from_string (an_application_home)
		end

	set_desktop_shortcut (a_desktop_shortcut: like has_desktop_shortcut)
			-- Set `has_desktop_shortcut' to `a_desktop_shortcut'.
		do
			has_desktop_shortcut := a_desktop_shortcut
		ensure
			desktop_shortcut_assigned: has_desktop_shortcut = a_desktop_shortcut
		end

	set_program_menu_path (a_program_menu_path: like program_menu_path)
			-- Set `program_menu_path' to `a_program_menu_path'.
		do
			program_menu_path := a_program_menu_path
		ensure
			program_menu_path_assigned: program_menu_path = a_program_menu_path
		end

feature -- Access

	application_home: EL_DIR_PATH

feature -- Basic operations

	install
			--
		require
			application_home_is_set: application_home /= Void
		local
			program_file_link_path: EL_FILE_PATH
			target_path: EL_FILE_PATH
		do
			log.enter ("install")
			create_directory (path_steps (application_home))
			create_directory (path_steps (program_menu_path))

			File_source_directories.linear_representation.do_all (agent place_files_in_destination)
			target_path := file_path (application_home, Launch_command_relative_path)

			shell_link.load (File_link_path)
			shell_link.set_target_path (target_path)
			if not Launch_command_arguments.is_empty then
				shell_link.set_command_arguments (Launch_command_arguments)
			end
			shell_link.set_working_directory (directory_path_containing_file (target_path))
			shell_link.set_icon_location (Shell_link_icon_path, 1)

			program_file_link_path := file_path (program_menu_path, Launch_shortcut_name)
			program_file_link_path.add_extension ("lnk")

			shell_link.save (program_file_link_path)
			if has_desktop_shortcut then
				shell_link.save (Desktop_link_path)
			end
			log.exit
		end

feature {NONE} -- Implementation

	place_files_in_destination (directory: STRING)
			--
		local
			l_command: STRING
			source_path, destination_path: EL_DIR_PATH
			source_drive, destination_drive: CHARACTER
		do
			log.enter_with_args ("place_files_in_destination", << directory >>)
			create source_path.make_from_string (Install_files_root)
			source_path.extend (directory)
			create destination_path.make_from_string (application_home)

			source_drive := source_path @ 1
			destination_drive := application_home @ 1

			if source_drive = destination_drive then
				create l_command.make_from_string (Move_directory_os_command_template)
			else
				create l_command.make_from_string (Copy_directory_os_command_template)
				destination_path.extend (directory)
			end
			l_command.replace_substring_all ("$source", source_path)
			l_command.replace_substring_all ("$application_home", destination_path)
			log.put_string (l_command)
			log.put_new_line
			system (l_command)
			log.exit
		end

	has_desktop_shortcut: BOOLEAN

	shell_link: EL_SHELL_LINK

	source: STRING

	File_link_path: EL_FILE_PATH
			-- relative to installation root
		do
			create Result.make_from_string (install_files_root)
			Result.extend (File_link_relative_path)
		end

feature -- Constants

	Default_application_home: STRING
			--
		deferred
		end

	Default_menu_folder_name: STRING
			--
		deferred
		end

	Launch_shortcut_name: STRING
			--
		deferred
		end

	Desktop_link_path: EL_FILE_PATH
			--
		once
			create Result.make_from_string (get ("USERPROFILE"))
			Result.extend ("Desktop")
			Result.extend (Launch_shortcut_name)
			Result.add_extension ("lnk")
		end

	File_source_directories: ARRAY [STRING]
			--
		deferred
		end

	File_link_relative_path: STRING
			-- relative to installation root
		deferred
		end

	Launch_command_relative_path: STRING
			-- relative to installation root
		deferred
		end

	Launch_command_arguments: STRING
			-- Arguments to launch command
		once
			create Result.make_empty
		end

	Executable_relative_path: STRING
			-- relative to installation root
		deferred
		end

	Shell_link_icon_path: STRING
			--
		once
			Result := file_path (application_home, Executable_relative_path)
		end

feature -- OS command templates

	Copy_directory_OS_command_template: STRING = "xcopy /I /S /Y %"$source%" %"$application_home%""

	Move_directory_OS_command_template: STRING = "move /Y %"$source%" %"$application_home%""

feature -- Window  constants

	Window_title: STRING
			--
		deferred
		end

	Window_icon: EV_PIXMAP
			--
		deferred
		end

	Application_logo_pixmap: EV_PIXMAP
			--
		deferred
		end

	Application_icons: EL_APPLICATION_ICONS
			--
		once
			create Result
		end

end
