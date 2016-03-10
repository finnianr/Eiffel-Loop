note
	description: "Summary description for {EL_EXECUTION_ENVIRONMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-02-02 11:40:20 GMT (Sunday 2nd February 2014)"
	revision: "5"

class
	EL_EXECUTION_ENVIRONMENT

inherit
	EL_CROSS_PLATFORM [EL_EXECUTION_ENVIRONMENT_IMPL]

	EXECUTION_ENVIRONMENT
		rename
			sleep as sleep_nanosecs,
			current_working_directory as current_working_directory_obselete
		end

	EL_MODULE_ARGS
		export
			{NONE} all
		end

	EL_MODULE_STRING
		export
			{NONE} all
		end

	EL_SHARED_ENVIRONMENTS
		export
			{NONE} all
		end

	EL_MODULE_BUILD_INFO
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_platform
			create home_directory.make_from_path (Home_directory_path)
			user_profile_dir := implementation.user_profile_dir
			user_configuration_dir := home_directory.joined_dir_path (implementation.user_configuration_steps)
			user_data_directory_path := home_directory.joined_dir_path (implementation.user_data_directory_steps)
			application_installation_dir := apps_install_path.joined_dir_path (Build_info.installation_sub_directory)

			application_bin_path := application_installation_dir.twin
			application_bin_path.append_file_path ("bin")

			executable_path := create_executable_path
--			io.put_string ("Executable path: " + executable_path.to_string.out)
--			io.put_new_line
		end

feature -- Access

	variable_dir_path (name: READABLE_STRING_GENERAL): EL_DIR_PATH
		do
			Result := item (name)
		end

	application_bin_path: EL_DIR_PATH
			-- Installed application executable directory

	application_installation_dir: EL_DIR_PATH
			--

	apps_install_path: EL_DIR_PATH
			--
		do
			create Result.make (implementation.Apps_install_dir)
		end

	command_directory_path: EL_DIR_PATH
			-- Directory containing this application's executable command
		do
			Result := executable_path.parent
		end

	current_working_directory: EL_DIR_PATH
		do
			create Result.make_from_path (current_working_path)
		end

	executable_search_path: EL_ASTRING
			--
		do
			create Result.make_from_unicode (item ("PATH"))
		end

	executable_name: EL_ASTRING
			-- Name of currently executing command
		local
			l_command_path: EL_FILE_PATH
		do
			create l_command_path.make_from_unicode (Args.command_name)
			Result := l_command_path.steps.last
		end

	executable_path: EL_FILE_PATH
			-- absolute path to currently executing command
			-- or empty path if not found

	system_command_dir: EL_DIR_PATH
			--
		do
			create Result.make (implementation.System_command_dir)
		end

	home_directory: EL_DIR_PATH

	user_profile_dir: EL_DIR_PATH

	user_configuration_dir: EL_DIR_PATH
			--
	user_data_directory_path: EL_DIR_PATH

	user_configuration_directory_name: STRING
			--
		do
			Result := implementation.User_configuration_directory_name
		end

feature -- Basic operations

	sleep (millisecs: INTEGER)
			--
		do
			sleep_nanosecs (millisecs * Nanosecs_per_millisec)
		end

feature -- Status setting

	set_utf_8_console_output
			-- Set Windows console to utf-8 code page (65001)
			-- WINDOWS ONLY, Unix has no effect.

			-- WARNING
			-- If the original code page is not restored on program exit after changing to 65001 (utf-8)
			-- this could effect subsequent programs that run in the same shell.
			-- Python scripts for example, might give a "LookupError: unknown encoding: cp65001".

		do
			last_code_page := implementation.console_code_page
			implementation.set_utf_8_console_output -- For Windows commands
		end

	restore_last_code_page
			-- Restore original Windows console code page
			-- WINDOWS ONLY, Unix has no effect.

			-- Use on program exit in case utf_8_console_output is set
		do
			implementation.set_console_code_page (last_code_page)
		end

feature -- Transformation

	application_dynamic_module_path (module_name: STRING): EL_FILE_PATH
		do
			Result := Application_bin_path + dynamic_module_name (module_name)
		end

	dynamic_module_name (module_name: EL_ASTRING): EL_ASTRING
			-- normalized name for platform
			-- name = "svg"
			-- 	Linux: Result = "libsvg.so"
			-- 	Windows: Result = "svg.dll"
		do
			create Result.make (module_name.count + 7)
			Result.append (Operating.C_library_prefix)
			Result.append (module_name)
			Result.append_character ('.')
			Result.append (Operating.Dynamic_module_extension)
		end

	command_path_abs (command: STRING): EL_FILE_PATH
			-- Absolute path to command in the search path
			-- Empty if not found
		local
			path_list, extensions: LIST [EL_ASTRING]
			base_permutation_path, full_permutation_path: EL_FILE_PATH
			extension: EL_ASTRING
		do
			create Result
			path_list := executable_search_path.split (Operating.Search_path_separator)
			extensions := implementation.Executable_file_extensions
			from path_list.start until not Result.is_empty or path_list.after loop
				create base_permutation_path.make (path_list.item)
				base_permutation_path.append_file_path (command)
				from extensions.start until not Result.is_empty or extensions.after loop
					full_permutation_path := base_permutation_path.twin
					extension := extensions.item
					if not extension.is_empty then -- Empty on Unix
						full_permutation_path.add_extension (extension)
					end
					if full_permutation_path.exists then
						Result := full_permutation_path
					else
						extensions.forth
					end
				end
				path_list.forth
			end
		end

feature -- Element change

	set_executable_search_path (env_path: EL_ASTRING)
			--
		do
			put (env_path.to_unicode, "PATH")
		end

	extend_executable_search_path (a_path: EL_ASTRING)
			--
		local
			new_path, bin_path: EL_ASTRING
		do
			new_path := executable_search_path
			bin_path := a_path.string

			if bin_path @ 1 = '"' and bin_path @ bin_path.count = '"' then
				bin_path.remove_head (1)
				bin_path.remove_tail (1)
			end
			-- if the path is not already set in env label "path"
			if new_path.substring_index (bin_path,1) = 0  then
				new_path.append_character (';')
				new_path.append_string (bin_path)
				set_executable_search_path (new_path)
			end
		end

feature {NONE} -- Implementation

	create_executable_path: EL_FILE_PATH
		do
			create Result.make_from_unicode (Args.command_name)
--			if not current_working_directory.is_parent_of (Result) then
--				Result := current_working_directory + Result
--			end

			if Result.exists then
				-- In development project
			else
				-- Is installed
				Result := Application_bin_path + Executable_name
			end
		end

	last_code_page: NATURAL
		-- last windows code page

feature -- Constants

	Nanosecs_per_millisec: INTEGER_64 = 1000000

end
