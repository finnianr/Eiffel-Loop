note
	description: "[
		Selects an application to launch from an array of sub-applications by either user input or command switch.
		Can also install/uninstall any sub-applications that have installation configuration info asssociated with them.
		(System file context menu or system application launch menu)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 22:21:59 GMT (Friday 18th December 2015)"
	revision: "7"

deferred class
	EL_MULTI_APPLICATION_ROOT [B -> EL_BUILD_INFO] -- Generic to make sure scons generated BUILD_INFO is compiled from project source

inherit
	EL_INSTALLER_CONSTANTS

	EL_MEMORY

	EL_MODULE_ARGS

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_DIRECTORY

	EL_MODULE_ENVIRONMENT

	EL_MODULE_STRING_8

	EL_MODULE_LOGGING

	EL_MODULE_LOG

	EL_MODULE_BUILD_INFO

	EL_LOG_CONSTANTS

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

feature {NONE} -- Initialization

	make
			--
		local
			output_dir: EL_DIR_PATH
			output_dir_steps, temp_dir_steps: EL_PATH_STEPS
		do
			redirected_output := File_system.closed_none_plain_text
			application_list := new_application_list

			output_dir := Redirected_file_path.parent
			if Is_console then
				-- Force console creation. Needed for set_utf8_console_output to work in Windows
				io.put_character ({ASCII}.back_space.to_character_8)
				Environment.Execution.set_utf_8_console_output
					-- Only has effect in Windows command console
			else
				set_redirected_output (output_dir)
			end
			-- Must be called before current_working_directory changes
			if Environment.Execution.Executable_path.is_file then
			end

			Args.set_boolean_from_word_option ({EL_LOG_COMMAND_OPTIONS}.Logging, agent logging.activate)
				-- Partial logging initialization. Cannot do full one until launcher launch.

			if Args.index_of_word_option ({EL_COMMAND_OPTIONS}.Install) = 1 then
				if is_package_installable then
					if has_installer then
						launch
					else
						install
					end
				else
					io.put_string ("ERROR%NTo install application must be in %"package/$PLATFORM_NAME/bin%" directory.%N")
				end
			else
				launch
			end
			if Is_console then
				Environment.Execution.restore_last_code_page
					-- FOR WINDOWS
					-- If the original code page is not restored after changing to 65001 (utf-8)
					-- this could effect subsequent programs that run in the same shell.
					-- Python for example might give a "LookupError: unknown encoding: cp65001" error.
			else
				redirected_output.close
				redirected_output.delete

				temp_dir_steps := Environment.Operating.Temp_directory_path
				from output_dir_steps := output_dir until output_dir_steps ~ temp_dir_steps loop
					File_system.delete_if_empty (output_dir_steps)
					output_dir_steps.finish
					output_dir_steps.remove
				end
			end
		end

feature -- Access

	application_list: EL_ARRAYED_LIST [EL_SUB_APPLICATION]

feature -- Basic operations

	launch
			--
		do
			application_list.find_first (Args.option_name (1), agent {EL_SUB_APPLICATION}.new_option_name)
			if application_list.after then
				io_put_menu
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

				io.put_new_line
				io.put_new_line

				application_list.wipe_out
				-- Causes a crash on some multi-threaded applications
				full_collect; full_collect
					-- Double collect required for EL_GC_PROTECTED_OBJECT which releases
					-- protected objects for collection as a side effect of dispose
			end
		end

	install
			--
		require
			package_installable: is_package_installable
		local
			package_dir, destination_dir: EL_DIR_PATH
			find_directories_command: EL_FIND_DIRECTORIES_COMMAND
			template: ZSTRING
		do
			destination_dir := Directory.Application_installation
			package_dir := Package_dir_steps

			template := once "Installing: %S%NSource: %S%NDestination: %S%N"
			io.put_string (template #$ [Args.command_name, package_dir, destination_dir])
			if not destination_dir.exists then
				File_system.make_directory (destination_dir)
			end

			create find_directories_command.make (package_dir)
			find_directories_command.disable_recursion
			find_directories_command.execute
			across find_directories_command.path_list as source_dir loop
				if not_same_directory (source_dir.item, package_dir) then
					copy_directory (source_dir.item, destination_dir)
				end
			end
			install_menus
			io.put_string ("DONE")
			io.put_new_line
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
		local
			package_dir: EL_DIR_PATH
		do
			package_dir := Package_dir_steps
			if package_dir.exists then
				Result := not named_directory (package_dir).is_empty
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

	set_redirected_output (output_dir: EL_DIR_PATH)
		local
			output_file_path: EL_FILE_PATH
			i: INTEGER
		do
			File_system.make_directory (output_dir)
			output_file_path := Redirected_file_path
			from until not output_file_path.exists loop
				output_file_path := Redirected_file_path.with_new_extension (i.out.as_string_32 + ".txt")
				i := i + 1
			end
			create redirected_output.make_open_write (output_file_path)
			io.set_file_default (redirected_output)
		end

	copy_directory (package_dir: EL_DIR_PATH; destination_dir: EL_DIR_PATH)
		do
			io.put_string (package_dir.to_string); io.put_new_line
			io.put_string (destination_dir.to_string); io.put_new_line
			File_system.copy_tree (package_dir, destination_dir)
		end

	not_same_directory (package_sub_dir: EL_DIR_PATH; package_dir: EL_DIR_PATH): BOOLEAN
		do
			Result := package_sub_dir /~ package_dir
		end

	io_put_menu
			--
		do
			io.put_new_line
			across application_list as application loop
				io.put_integer (application.cursor_index)
				io.put_string (". Command option: -")
				io.put_string (application.item.option_name.as_string_8)
				io.put_new_line
				io.put_new_line
				io.put_string (String_8.spaces (Tab_width, 1))
				io.put_string ("DESCRIPTION: ")
				io.put_new_line
				line_count := 0
				across application.item.description.split ('%N') as line loop
					line_count := line_count + 1
					io.put_string (String_8.spaces (Tab_width, 2))
					io.put_string (line.item)
					io.put_new_line
				end
				io.put_new_line
			end
		end

	user_selection: INTEGER
			-- Ask user to select
		do
			io.put_string ("Select program by number: ")
			io.read_line
			if io.last_string.is_integer then
				Result := io.last_string.to_integer
			end
		end

	Redirected_file_path: EL_FILE_PATH
		local
			name: ZSTRING
			l_location: EL_DIR_PATH
		once
			if Args.argument_count >= 1 then
				name := Args.item (1)
				name.remove_head (1)
			else
				name := "Eiffel-app"
			end
			l_location := Environment.Operating.Temp_directory_path.joined_dir_path (Build_info.installation_sub_directory)
			Result := l_location + name
			Result.add_extension ("txt")
		end


	application_types: ARRAY [TYPE [EL_SUB_APPLICATION]]
			--
		deferred
		end

feature {NONE} -- Implementation: attributes

	line_count: INTEGER

	redirected_output: PLAIN_TEXT_FILE

feature {NONE} -- Constants

	Tab_width: INTEGER = 3

	Double_directory_separator: STRING
			--
		once
			create Result.make_filled (Operating_environment.directory_separator, 2)
		end

	is_console: BOOLEAN
			-- Is this a console application
		once
			Result := True
		end

end
