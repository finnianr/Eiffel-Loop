note
	description: "Routines related to current application executable accessible via [$source EL_MODULE_EXECUTABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-04 16:04:57 GMT (Wednesday 4th August 2021)"
	revision: "3"

deferred class
	EL_EXECUTABLE_I

inherit
	ANY

	EL_MODULE_ARGS EL_MODULE_DIRECTORY

	EL_SHARED_OPERATING_ENVIRON

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

feature {NONE} -- Initialization

	make
		do
			path := Args.command_path.twin
			name := Args.command_path.base
			if path.exists then
				-- In development project
			else
				-- Is installed
				path := Directory.Application_bin + name
			end
		end

feature -- Access

	absolute_path (a_name: STRING): EL_FILE_PATH
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

	parent_dir: EL_DIR_PATH
			-- Directory containing this application's executable command
			-- (command_directory_path)
		do
			Result := path.parent
		end

	path: EL_FILE_PATH
		-- absolute path to currently executing command
		-- or empty path if not found

	search_path: ZSTRING
		do
			Result := Execution_environment.item ("PATH")
		end

	search_path_list: ARRAYED_LIST [EL_DIR_PATH]
			--
		local
			list: EL_ZSTRING_LIST
		do
			create list.make_with_separator (search_path, search_path_separator, False)
			create Result.make (list.count)
			across list as l_path loop
				Result.extend (l_path.item)
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
			Execution_environment.put (env_path.to_unicode, "PATH")
		end

feature -- Status report

	Is_work_bench: BOOLEAN
			-- True if application is called from within EiffelStudio
		once
			Result := parent_dir.base.same_string ("W_code")
		end

	is_finalized: BOOLEAN
			-- True if application is a finalized executable
		do
			Result := not is_work_bench
		end

	search_path_has (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if executable `name' is in the environment search path `PATH'
		do
			across search_path_list as l_path until Result loop
				Result := Shared_directory.named (l_path.item).has_executable (a_name)
			end
		end

feature -- Constants

	User_qualified_name: ZSTRING
		-- executable name qualified with username
		once
			Result := name + "-" + Operating_environ.user_name
		end

end