note
	description: "Summary description for {EL_EXECUTION_ENVIRONMENT_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-22 16:12:47 GMT (Wednesday 22nd June 2016)"
	revision: "5"

deferred class
	EL_EXECUTION_ENVIRONMENT_I

inherit
	EXECUTION_ENVIRONMENT
		rename
			sleep as sleep_nanosecs,
			current_working_directory as current_working_directory_obselete
		end

	EL_MODULE_ARGS
		export
			{NONE} all
		end

	EL_SHARED_ENVIRONMENTS
		export
			{NONE} all
		end

	EL_MODULE_DIRECTORY

feature {EL_MODULE_EXECUTION_ENVIRONMENT} -- Initialization

	make
		do
			executable_path := new_executable_path
			create directory_stack.make (1)
--			io.put_string ("Executable path: " + executable_path.to_string.out)
--			io.put_new_line
		end

feature -- Access

	command_directory_path: EL_DIR_PATH
			-- Directory containing this application's executable command
		do
			Result := executable_path.parent
		end

	console_code_page: NATURAL
			-- For windows. Returns 0 in Unix
		deferred
		end

	data_dir_name_prefix: ZSTRING
		deferred
		end

	executable_file_extensions: LIST [ZSTRING]
		deferred
		end

	executable_name: ZSTRING
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

	executable_search_path: ZSTRING
		do
			Result := item ("PATH")
		end

	executable_search_list: EL_DIRECTORY_LIST
			--
		local
			list: EL_ZSTRING_LIST
		do
			create list.make_with_separator (executable_search_path, search_path_separator, False)
			create Result.make (list.count)
			across list as path loop
				Result.extend (create {EL_DIRECTORY}.make (path.item))
			end
		end

	search_path_separator: CHARACTER_32
		deferred
		end

	user_configuration_directory_name: ZSTRING
			--
		deferred
		end

	variable_dir_path (name: READABLE_STRING_GENERAL): EL_DIR_PATH
		do
			if attached {STRING_32} item (name) as environ_path then
				Result := environ_path
			else
				create Result
			end
		end

	last_code_page: NATURAL
		-- last windows code page

feature -- Basic operations

	sleep (millisecs: INTEGER)
			--
		do
			sleep_nanosecs (millisecs * Nanosecs_per_millisec)
		end

	pop_current_working
		require
			valid_directory_stack_empty: not is_directory_stack_empty
		do
			change_working_path (directory_stack.item)
			directory_stack.remove
		end

	push_current_working (a_dir: EL_DIR_PATH)
		do
			directory_stack.put (current_working_path)
			change_working_path (a_dir)
		end

feature -- Status report

	is_work_bench_mode: BOOLEAN
			-- Is application called from within EiffelStudio
		do
			Result := executable_path.parent.base ~ W_code
		end

	is_directory_stack_empty: BOOLEAN
		do
			Result := directory_stack.is_empty
		end

feature -- Status setting

	restore_last_code_page
			-- Restore original Windows console code page
			-- WINDOWS ONLY, Unix has no effect.

			-- Use on program exit in case utf_8_console_output is set
		do
			set_console_code_page (last_code_page)
		end

	set_utf_8_console_output
			-- Set Windows console to utf-8 code page (65001)
			-- WINDOWS ONLY, Unix has no effect.

			-- WARNING
			-- If the original code page is not restored on program exit after changing to 65001 (utf-8)
			-- this could effect subsequent programs that run in the same shell.
			-- Python scripts for example, might give a "LookupError: unknown encoding: cp65001".

		do
			last_code_page := console_code_page
		end

feature -- Transformation

	application_dynamic_module_path (module_name: STRING): EL_FILE_PATH
		do
			Result := Directory.Application_bin + dynamic_module_name (module_name)
		end

	command_path_abs (command: STRING): EL_FILE_PATH
			-- Absolute path to command in the search path
			-- Empty if not found
		local
			path_list, extensions: LIST [ZSTRING]
			base_permutation_path, full_permutation_path: EL_FILE_PATH
			extension: ZSTRING
		do
			create Result
			path_list := executable_search_path.split (Operating.Search_path_separator)
			extensions := executable_file_extensions
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

	dynamic_module_name (module_name: ZSTRING): ZSTRING
			-- normalized name for platform
			-- name = "svg"
			-- 	Linux: Result = "libsvg.so"
			-- 	Windows: Result = "svg.dll"
		do
			create Result.make (module_name.count + 7)
			Result.append_string_general (Operating.C_library_prefix)
			Result.append (module_name)
			Result.append_character ('.')
			Result.append_string_general (Operating.Dynamic_module_extension)
		end

feature -- Element change

	extend_executable_search_path (a_path: ZSTRING)
			--
		local
			new_path, bin_path: ZSTRING
		do
			new_path := executable_search_path
			bin_path := a_path.twin
			if bin_path.has_quotes (2) then
				bin_path.remove_quotes
			end
			-- if the path is not already set in env label "path"
			if new_path.substring_index (bin_path,1) = 0  then
				new_path.append_character (';')
				new_path.append (bin_path)
				set_executable_search_path (new_path)
			end
		end

	set_executable_search_path (env_path: ZSTRING)
			--
		do
			put (env_path.to_unicode, "PATH")
		end

feature {NONE} -- Implementation

	new_executable_path: EL_FILE_PATH
		do
			create Result.make_from_unicode (Args.command_name)
--			if not current_working_directory.is_parent_of (Result) then
--				Result := current_working_directory + Result
--			end

			if Result.exists then
				-- In development project
			else
				-- Is installed
				Result := Directory.Application_bin + Executable_name
			end
		end

	set_console_code_page (code_page_id: NATURAL)
			-- For windows commands. Does nothing in Unix
		deferred
		end

	directory_stack: ARRAYED_STACK [EL_DIR_PATH]

feature -- Constants

	Nanosecs_per_millisec: INTEGER_64 = 1000000

	W_code: ZSTRING
		once
			Result := "W_code"
		end

end
