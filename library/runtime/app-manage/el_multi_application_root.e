note
	description: "[
		Selects an application to launch from an array of sub-applications by either user input or command switch.
		Can also install/uninstall any sub-applications that have installation configuration info asssociated with them.
		(System file context menu or system application launch menu)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-21 10:57:06 GMT (Saturday 21st January 2017)"
	revision: "4"

deferred class
	EL_MULTI_APPLICATION_ROOT [B -> EL_BUILD_INFO] -- Generic to make sure scons generated BUILD_INFO is compiled from project source

inherit
	EL_INSTALLER_CONSTANTS

	EL_MODULE_ARGS

	EL_MODULE_COMMAND

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_OS

	EL_MODULE_DIRECTORY

	EL_MODULE_ENVIRONMENT

	EL_MODULE_STRING_8

	EL_MODULE_LOGGING

	EL_MODULE_LIO
		rename
			Lio as Later_lio
		end

	EL_MODULE_BUILD_INFO

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

	THREAD_CONTROL

feature {NONE} -- Initialization

	make
			--
		do
			application_list := new_application_list
			if not Args.has_silent then
				-- Force console creation. Needed to set `{EL_EXECUTION_ENVIRONMENT_I}.last_codepage'

				io.put_character ({ASCII}.back_space.to_character_8)

--				Environment.Execution.set_utf_8_console_output
					-- Only has effect in Windows command console
			end
			-- Must be called before current_working_directory changes
			if Environment.Execution.Executable_path.is_file then
			end

			if Args.index_of_word_option ({EL_COMMAND_OPTIONS}.Install) = 1 then
				if is_package_installable then
					if has_installer then
						launch
					else
						install
					end
				else
					lio.put_string (Error_empty_package_bin)
				end
			else
				launch
			end
--				Environment.Execution.restore_last_code_page
--				FOR WINDOWS
--				If the original code page is not restored after changing to 65001 (utf-8)
--				this could effect subsequent programs that run in the same shell.
--				Python for example might give a "LookupError: unknown encoding: cp65001" error.
		end

feature -- Access

	application_list: EL_ARRAYED_LIST [EL_SUB_APPLICATION]

feature -- Basic operations

	launch
			--
		do
			application_list.find_first (Args.option_name (1), agent {EL_SUB_APPLICATION}.new_option_name)
			if application_list.after then
				if not Args.has_silent then
					io_put_menu
				end
				application_list.go_i_th (user_selection)
			end
			if not application_list.off then

				-- Execute application
				if attached {EL_INSTALLER_SUB_APPLICATION} application_list.item as installer then
					-- Might also be uninstaller
					installer.make_installer (Current)
				else
					application_list.item.make
				end

				lio.put_new_line
				lio.put_new_line

				application_list.wipe_out
				-- Causes a crash on some multi-threaded applications
				{MEMORY}.full_collect
			end
		end

	install
			--
		require
			package_installable: is_package_installable
		local
			destination_dir: EL_DIR_PATH; find_directories_cmd: like Command.new_find_directories
		do
			destination_dir := Directory.Application_installation
			debug ("installer")
				destination_dir := Directory.Desktop.joined_dir_path (Build_info.installation_sub_directory)
			end

			lio.put_string (Installing_template #$ [Args.command_name, Package_dir, destination_dir])
			File_system.make_directory (destination_dir)

			find_directories_cmd := Command.new_find_directories (Package_dir)
			find_directories_cmd.set_depth (1 |..| 1)
			find_directories_cmd.execute
			across find_directories_cmd.path_list as source_dir loop
				copy_directory (source_dir.item, destination_dir)
			end
			install_menus
			lio.put_line ("DONE")
		end

	install_menus
		do
			across application_list as application loop
				if attached {EL_INSTALLER_SUB_APPLICATION} application.item as installer_app then
					installer_app.set_root (Current)
				end
				if application.item.is_installable then
					application.item.install
				end
			end
		end

feature -- Status query

	is_package_installable: BOOLEAN
		do
			if Package_dir.exists then
				Result := not named_directory (Package_dir).is_empty
			end
		end

	has_installer: BOOLEAN
		do
			Result := across application_list as application some application.item.option_name ~ {EL_COMMAND_OPTIONS}.Install  end
		end

feature {NONE} -- Implementation

	new_application_list: like application_list
		do
			create Result.make (application_types.count)
			across application_types as app_type loop
				check attached {EL_SUB_APPLICATION} Eiffel.new_instance_of (app_type.item.type_id) as application then
					Result.extend (application)
				end
			end
			Result.extend (create {EL_VERSION_APP})
			Result.compare_objects
		end

	copy_directory (source_dir: EL_DIR_PATH; destination_dir: EL_DIR_PATH)
		do
			lio.put_line (source_dir.to_string)
			lio.put_line (destination_dir.to_string)
			OS.copy_tree (source_dir, destination_dir)
		end

	io_put_menu
			--
		do
			lio.put_new_line
			across application_list as application loop
				lio.put_integer (application.cursor_index)
				lio.put_string (". Command option: -")
				lio.put_line (application.item.option_name.as_string_8)

				lio.put_new_line
				lio.put_string (String_8.spaces (Tab_width, 1))
				lio.put_line ("DESCRIPTION: ")
				line_count := 0
				across application.item.description.split ('%N') as line loop
					line_count := line_count + 1
					lio.put_string (String_8.spaces (Tab_width, 2))
					lio.put_line (line.item)
				end
				lio.put_new_line
			end
		end

	user_selection: INTEGER
			-- Ask user to select
		do
			if not Args.has_silent then
				io.put_string ("Select program by number: ")
				io.read_line
				if io.last_string.is_integer then
					Result := io.last_string.to_integer
				end
			end
		end

	application_types: ARRAY [TYPE [EL_SUB_APPLICATION]]
			--
		deferred
		end

feature {NONE} -- Implementation: attributes

	line_count: INTEGER

feature {NONE} -- Constants

	Error_empty_package_bin: STRING = "[
		ERROR: No executable found in "package/$PLATFORM_NAME/bin" directory.
		
	]"

	Installing_template: ZSTRING
		once
			Result := "[
				Installing: #
				Source: #
				Destination: #
				
			]"
		end

	Double_directory_separator: STRING
			--
		once
			create Result.make_filled (Operating_environment.directory_separator, 2)
		end

	Lio: EL_LOGGABLE
			-- This is a temporary lio until the logging is initialized in `EL_SUB_APPLICATION'
		once
			Result := new_lio
		end

	Tab_width: INTEGER = 3

end
