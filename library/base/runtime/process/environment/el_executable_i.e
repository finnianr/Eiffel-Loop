note
	description: "Routines related to current application executable accessible via [$source EL_MODULE_EXECUTABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-03 18:46:41 GMT (Friday 3rd November 2023)"
	revision: "15"

deferred class
	EL_EXECUTABLE_I

inherit
	ANY

	EL_MODULE_ARGS EL_MODULE_DIRECTORY

	EL_SHARED_OPERATING_ENVIRON

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

feature {NONE} -- Initialization

	make
		do
			path := Args.command_path.twin
			if path.exists then
				-- In development project
			else
				-- Is installed
				path := Directory.Application_bin + name
			end
		end

feature -- Compiled modules

	application_dynamic_module_path (module_name: STRING): FILE_PATH
		do
			Result := Directory.Application_bin + dynamic_module_name (module_name)
		end

	dynamic_module_name (module_name: READABLE_STRING_GENERAL): ZSTRING
			-- normalized name for platform
			-- name = "svg"
			-- 	Linux: Result = "libsvg.so"
			-- 	Windows: Result = "svg.dll"
		do
			create Result.make (module_name.count + 7)
			Result.append_string_general (Operating_environ.C_library_prefix)
			Result.append_string_general (module_name)
			Result.append_character ('.')
			Result.append_string_general (Operating_environ.dynamic_module_extension)
		end

feature -- Access

	absolute_path (a_name: STRING): FILE_PATH
			-- Absolute path to command `a_name' if found in the search path
			-- `Result.is_empty' if not found
		local
			extension_list: LIST [ZSTRING]; found: BOOLEAN
		do
			create Result
			extension_list := file_extensions
			across search_path.split (search_path_separator) as l_path until found loop
				Result.set_path (l_path.item)
				Result.append_step (a_name)
				if extension_list.is_empty then
					found := Result.exists -- Empty on Unix
				else
					-- Try all extention permutations on Windows
					across extension_list as extension until found loop
						if extension.is_first then
							Result.add_extension (extension.item)
						else
							Result.replace_extension (extension.item)
						end
						found := Result.exists
					end
				end
			end
		end

	file_extensions: EL_ZSTRING_LIST
		deferred
		end

	name: ZSTRING
			-- Name of currently executing command
		do
			Result := path.base
		end

	parent_dir: DIR_PATH
			-- Directory containing this application's executable command
			-- (command_directory_path)
		do
			Result := path.parent
		end

	path: FILE_PATH
		-- absolute path to currently executing command
		-- or empty path if not found

	search_path: ZSTRING
		do
			if attached Execution_environment.item (Var_path) as str then
				Result := str
			else
				create Result.make_empty
			end
		end

	search_path_list: ARRAYED_LIST [DIR_PATH]
		do
			Result := Once_search_path_list

			if attached search_path as l_search_path and then attached crc_generator as crc then
				crc.add_string (l_search_path)
				-- Check if PATH has changed since last call
				if path_check_sum /= crc.checksum then
					path_check_sum := crc.checksum
					Result.wipe_out
					across l_search_path.split (search_path_separator) as split loop
						if split.item_count > 0 then
							Result.extend (split.item)
						end
					end
				end
			end
		end

	search_path_separator: CHARACTER_32
		deferred
		end

feature -- Basic operations

	extend_search_path (a_path: ZSTRING)
			--
		local
			new_path, bin_path: ZSTRING
		do
			new_path := search_path
			bin_path := a_path.twin
			if bin_path.has_quotes (2) then
				bin_path.remove_quotes
			end
			-- if the path is not already set in env label "path"
			if new_path.substring_index (bin_path,1) = 0  then
				new_path.append_character (';')
				new_path.append (bin_path)
				set_search_path (new_path)
			end
		end

	set_search_path (env_path: ZSTRING)
			--
		do
			Execution_environment.put (env_path.to_unicode, Var_path)
		end

feature -- Status report

	Is_work_bench: BOOLEAN
			-- True if application is called from within EiffelStudio
		once
			Result := parent_dir.same_base ("W_code")
		end

	is_finalized: BOOLEAN
			-- True if application is a finalized executable
		do
			Result := not is_work_bench
		end

	search_path_has (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if executable `name' is in the environment search path `PATH'
		deferred
		end

feature {NONE} -- Internal attributes

	path_check_sum: NATURAL

feature -- Constants

	Once_search_path_list: ARRAYED_LIST [DIR_PATH]
		once
			create Result.make (0)
		end

	User_qualified_name: ZSTRING
		-- executable name qualified with username
		once
			Result := name + "-" + Operating_environ.user_name
		end

	Var_path: STRING = "PATH"

end