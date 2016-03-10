note
	description: "[
		Selects an application to launch from an array of sub-applications by either user input or command switch.
		Can also install/uninstall any sub-applications that have installation configuration info asssociated with them.
		(System file context menu or system application launch menu)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-24 15:19:11 GMT (Wednesday 24th July 2013)"
	revision: "4"

deferred class
	EL_MULTI_APPLICATION_ROOT [B -> EL_BUILD_INFO] -- Generic to make sure scons generated BUILD_INFO is compiled from project source

inherit
	EL_MEMORY

	EL_MODULE_ARGS

	EL_MODULE_ENVIRONMENT

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_DIRECTORY

	EL_MODULE_TYPING

	EL_MODULE_STRING

	EL_MODULE_LOGGING

	EL_MODULE_LOG

	EL_MODULE_BUILD_INFO

	EL_LOG_CONSTANTS

feature {NONE} -- Initialization

	make
			--
		local
			output_dir: EL_DIR_PATH
			output_dir_steps, temp_dir_steps: EL_PATH_STEPS
		do
			redirected_output := File_system.closed_none_plain_text
			application_list := create_application_list

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

			Args.set_boolean_from_word_option (Command_arg_activate_logging, agent logging.activate)
				-- Partial logging initialization. Cannot do full one until launcher launch.

			if Args.index_of_word_option ("install") = 1 then
				if is_package_installable then
					install
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

feature {NONE} -- Basic operations

	launch
			--
		local
			command_option_name: EL_ASTRING
		do
			if Args.argument_count >= 1 and then Args.argument (1).starts_with ("-") then
				command_option_name := Args.argument_latin (1).to_unicode
				command_option_name.remove_head (1)
			else
				create command_option_name.make_empty
			end
			application_list.find_first (command_option_name, agent {EL_SUB_APPLICATION}.latin_option_name)
			if application_list.after then
				io_put_menu
				application_list.go_i_th (user_selection)
			end
			if not application_list.off then

				-- Execute application
				if attached {EL_UNINSTALL_APP} application_list.item as uninstall_app then
					uninstall_app.make (application_list)
				else
					application_list.item.make
				end

				io.put_new_line
				io.put_new_line

				application_list.wipe_out
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
		do
			destination_dir := Environment.Execution.Application_installation_dir
			package_dir := Package_dir_steps
			io.put_string (
				String.template ("Installing: $S%NSource: $S%NDestination: $S%N").substituted (
					<< Args.command_name, package_dir, destination_dir >>
				)
			)
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
			across application_list as application loop
				if application.item.is_installable then
					application.item.install (application_list)
				end
			end
			io.put_string ("DONE")
			io.put_new_line
		end

feature -- Status query

	is_package_installable: BOOLEAN
		local
			l_directory: EL_DIRECTORY
			package_dir: EL_DIR_PATH
		do
			package_dir := Package_dir_steps
			if package_dir.exists then
				create l_directory.make (package_dir)
				Result := not l_directory.is_empty
			end
		end

	is_work_bench_mode: BOOLEAN
			-- Is application called from within EiffelStudio
		do
			Result := Command_dir_steps.last ~ W_code
		end

feature {NONE} -- Implementation

	create_application_list: like application_list
		do
			create Result.make (application_types.count)
			across application_types as app_type loop
				check attached {EL_SUB_APPLICATION} Typing.new_instance_of (app_type.item.type_id) as application then
					Result.extend (application)
				end
			end
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
			create redirected_output.make_open_write (output_file_path.unicode)
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
				io.put_string (String.space_chars (Tab_width, 1))
				io.put_string ("DESCRIPTION: ")
				io.put_new_line
				line_count := 0
				application.item.description.split ('%N').do_all (
					agent (line: STRING)
						do
							line_count := line_count + 1
							io.put_string (String.space_chars (Tab_width, 2))
							io.put_string (line)
							io.put_new_line
						end
				)
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
			name: EL_ASTRING
			l_location: EL_DIR_PATH
		once
			if Args.argument_count >= 1 then
				name := Args.argument_latin (1)
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

	application_list: EL_ARRAYED_LIST [EL_SUB_APPLICATION]

	line_count: INTEGER

	redirected_output: PLAIN_TEXT_FILE

feature {NONE} -- Constants

	Package_dir_steps: EL_PATH_STEPS
		once
			if is_work_bench_mode then
				Result := << "package", Environment.Execution.item ("ISE_PLATFORM").to_string_8 >>
					-- Eg. "package/win64"
			else
				-- This is assumed to be the directory 'package/bin' unpacked by installer to a temporary directory
				Result := Command_dir_steps.twin
				Result.remove_tail (1)
			end
		end

	Command_dir_steps: EL_PATH_STEPS
		-- location of executable
		once
			Result := Environment.Execution.executable_path.parent
		end

	W_code: EL_ASTRING
		once
			Result := "W_code"
		end

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
