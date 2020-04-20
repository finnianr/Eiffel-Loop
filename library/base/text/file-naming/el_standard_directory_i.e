note
	description: "[
		Platform independent interface to standard OS directories accessible via [$source EL_MODULE_DIRECTORY]
	]"
	notes: "[
		**Gnome Convention**
		
		This class follows the Gnome convention of locating:

		* user data in `~/.local/share' (`user_local')
		* configuration in `~/.config' (`configuration')
		* non-essential data files in `~/.cache' (`cache')
		
		For MS Windows these directories are mapped to equivalent directories
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-20 10:59:10 GMT (Monday 20th April 2020)"
	revision: "14"

deferred class
	EL_STANDARD_DIRECTORY_I

inherit
	EXECUTION_ENVIRONMENT
		rename
			environ as environ_table,
			item as environ
		export
			{NONE} all
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_ENVIRONMENT

	EL_MODULE_BUILD_INFO

	EL_ZSTRING_CONSTANTS

feature -- Factory

	new_path (a_path: READABLE_STRING_GENERAL): EL_DIR_PATH
		do
			create Result.make (a_path)
		end

feature -- Access

	App_list: EL_ARRAYED_LIST [EL_DIR_PATH]
		once
			create Result.make_from_array (<< App_cache, App_configuration, App_data >>)
		end

	relative_parent (step_count: INTEGER): ZSTRING
			-- parent relative to current using '../'
			-- Returns '.' if `step_count' = 0
			-- Returns '../' if `step_count' = 1
			-- Returns '../../' if `step_count' = 2
			-- and so forth
		do
			if step_count = 0 then
				Result := character_string ('.')
			else
				Result := Parent.twin
				Result.multiply (step_count)
				Result.remove_head (1)
			end
		end

	separator: CHARACTER
		do
			Result := Operating_environment.Directory_separator
		end

feature -- Paths

	applications: EL_DIR_PATH
			-- In Windows this is "Program Files"
		deferred
		end

	desktop: EL_DIR_PATH
		deferred
		end

	desktop_common: EL_DIR_PATH
		deferred
		end

	documents: EL_DIR_PATH
		deferred
		end

	home: EL_DIR_PATH
		-- user home directory
		
		-- On Unix: /home/$USER
		-- On Windows 7: $HOMEDRIVE$HOMEPATH (Usually C:\Users\$USERNAME)
		deferred
		end

	system_command: EL_DIR_PATH
			--
		deferred
		end

	temporary: EL_DIR_PATH
		do
			Result := Environment.Operating.Temp_directory_path
		end

	user_local: EL_DIR_PATH
		-- On Unix: $HOME/.local/share
		-- On Windows 7: $LOCALAPPDATA (Usually C:\Users\$USERNAME\AppData\Local)
		deferred
		end

	working, current_working: EL_DIR_PATH
		do
			create Result.make_from_path (current_working_path)
		end

feature -- Path constants

	App_cache: EL_DIR_PATH
		once
			Result := cache.joined_dir_path (Relative_app_data)
		end

	App_configuration: EL_DIR_PATH
		once
			Result := configuration.joined_dir_path (Relative_app_data)
		end

	App_data: EL_DIR_PATH
		once
			Result := user_local.joined_dir_path (Relative_app_data)
		end

	Application_bin: EL_DIR_PATH
			-- Installed application executable directory
		once
			Result := application_installation.joined_dir_path ("bin")
		end

	Application_installation: EL_DIR_PATH
		once
			Result := applications.joined_dir_path (Build_info.installation_sub_directory)
		end

	Cache: EL_DIR_PATH
		-- non-essential application data files

		-- On Unix: $HOME/.cache
		-- On Windows 7: $HOMEDRIVE$HOMEPATH\.cache (Usually C:\Users\$USERNAME\.cache)
		once
			Result := home.joined_dir_path (".cache")
		end

	Configuration: EL_DIR_PATH
		-- application configuration data

		-- On Unix: /home/$USER/.config
		-- On Windows 7: $HOMEDRIVE$HOMEPATH\.config (Usually C:\Users\$USERNAME\.config)
		once
			Result := home.joined_dir_path (".config")
		end

	Relative_app_data: EL_DIR_PATH
		-- path to application data files relative to `local_share' directory
		once
			Result := Build_info.installation_sub_directory.to_string
		end

	Users: EL_DIR_PATH
		-- On Unix: /home
		-- On windows 7: C:\Users
		once
			Result := Home.parent
		end

feature -- Constants

	Parent: ZSTRING
		once
			Result := "/.."
		end

	Legacy_table: EL_HASH_TABLE [EL_DIR_PATH, EL_DIR_PATH]
		once
			create Result.make (<<
				[App_configuration, Legacy.app_configuration],
				[App_data, Legacy.app_data]
			>>)
		end

	Legacy: EL_LEGACY_DIRECTORY_I
		-- values for `app_data' and `configuration' prior to April 2020
		once
			create {EL_LEGACY_DIRECTORY_IMP} Result
		end

end
