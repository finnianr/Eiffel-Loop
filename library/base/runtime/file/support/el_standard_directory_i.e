note
	description: "[
		Platform independent interface to standard user and application directories accessible
		via ${EL_MODULE_DIRECTORY}
	]"
	notes: "[
		**Gnome Convention**
		
		User application directories follow the Gnome convention:

		* user application data in `~/.local/share' (`user_local')
		* configuration data in `~/.config' (`configuration')
		* non-essential data files in `~/.cache' (`cache')
		
		For MS Windows these directories are mapped to equivalent directories
		
			$HOMEDRIVE$HOMEPATH\.cache
			$HOMEDRIVE$HOMEPATH\.config
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 13:39:38 GMT (Sunday 22nd September 2024)"
	revision: "34"

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

	EL_OS_DEPENDENT

	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_ENVIRONMENT; EL_MODULE_BUILD_INFO

	EL_CHARACTER_32_CONSTANTS

feature -- Element change

	set_sub_app_dir (option_name: READABLE_STRING_GENERAL)
		-- called from `{EL_APPLICATION}.make_default' if application is switched on command line
		do
			Sub_app_dir.copy (create {DIR_PATH}.make (option_name))
		end

feature -- Factory

	new (a_path: READABLE_STRING_GENERAL): DIR_PATH
		do
			create Result.make (a_path)
		end

feature -- Access

	App_list: EL_ARRAYED_LIST [DIR_PATH]
		once
			create Result.make_from_array (<< App_cache, App_configuration, App_data >>)
		ensure
			cache_is_first: App_list.first = App_cache -- for migrating `Legacy_table' directories
		end

	relative_parent (step_count: INTEGER): ZSTRING
		-- parent relative to current using '../'
		-- Returns '.' if `step_count' = 0
		-- Returns '../' if `step_count' = 1
		-- Returns '../../' if `step_count' = 2
		-- and so forth
		do
			if step_count = 0 then
				Result := dot
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

feature -- System

	Users: DIR_PATH
		-- On Unix: /home
		-- On windows 7: C:\Users
		once
			Result := Home.parent
		end

	applications: DIR_PATH
			-- In Windows this is "Program Files"
		deferred
		end

	system_command: DIR_PATH
			--
		deferred
		end

	temporary: DIR_PATH
		do
			Result := Environment.Operating.Temp_directory_path
		end

	working, current_working: DIR_PATH
		do
			create Result.make_from_path (current_working_path)
		end

feature -- User

	Cache: DIR_PATH
		-- non-essential application data files

		-- On Unix: $HOME/.cache
		-- On Windows 7: $HOMEDRIVE$HOMEPATH\.cache (Usually C:\Users\$USERNAME\.cache)
		once
			Result := home #+ ".cache"
		end

	Configuration: DIR_PATH
		-- application configuration data

		-- On Unix: /home/$USER/.config
		-- On Windows 7: $HOMEDRIVE$HOMEPATH\.config (Usually C:\Users\$USERNAME\.config)
		once
			Result := home #+ ".config"
		end

	desktop: DIR_PATH
		deferred
		end

	desktop_common: DIR_PATH
		deferred
		end

	documents: DIR_PATH
		deferred
		end

	home: DIR_PATH
		-- user home directory

		-- On Unix: /home/$USER
		-- On Windows 7: $HOMEDRIVE$HOMEPATH (Usually C:\Users\$USERNAME)
		deferred
		end

	user_local: DIR_PATH
		-- On Unix: $HOME/.local/share
		-- On Windows 7: $LOCALAPPDATA (Usually C:\Users\$USERNAME\AppData\Local)
		deferred
		end

feature -- Application

	app_all_list: EL_ARRAYED_LIST [DIR_PATH]
		-- list of all application directories
		do
			create Result.make_from_array (<< App_cache, App_configuration, App_data >>)
			Result.compare_objects
		end

	App_cache: DIR_PATH
		once
			Result := cache #+ App_install_sub
		end

	App_configuration: DIR_PATH
		once
			Result := configuration #+ App_install_sub
		end

	App_data: DIR_PATH
		once
			Result := user_local #+ App_install_sub
		end

feature -- Sub-application

	Sub_app_cache: DIR_PATH
		once
			Result := new_sub_app_dir_path (App_cache)
		end

	Sub_app_configuration: DIR_PATH
		once
			Result := new_sub_app_dir_path (App_configuration)
		end

	Sub_app_data: DIR_PATH
		once
			Result := new_sub_app_dir_path (App_data)
		end

feature -- Installed locations

	Application_bin: DIR_PATH
		-- Installed application executable directory
		once
			Result := Application_installation #+ "bin"
		end

	Application_installation: DIR_PATH
		once
			Result := applications #+ App_install_sub
		end

feature -- Constants

	App_install_sub: DIR_PATH
		-- install sub-directory based on build information from ECF
		-- <company-name>/<app-name>
		once
			Result := Build_info.installation_sub_directory
		end

	Legacy: EL_LEGACY_DIRECTORY_I
		-- values for `app_data' and `configuration' prior to April 2020
		once
			create {EL_LEGACY_DIRECTORY_IMP} Result
		end

	Legacy_table: EL_HASH_TABLE [DIR_PATH, DIR_PATH]
		once
			create Result.make_assignments (<<
				[App_configuration, Legacy.app_configuration],
				[App_data, Legacy.app_data]
			>>)
		end

	Parent: ZSTRING
		once
			Result := "/.."
		end

	Relative_app_data: DIR_PATH
		-- .share/local for Unix
		-- AppData\Local for Windows
		once
			Result := user_local.relative_path (home)
		end

feature {NONE} -- Implementation

	new_sub_app_dir_path (dir_path: DIR_PATH): DIR_PATH
		do
			if attached Sub_app_dir as sub_dir and then not sub_dir.is_empty then
				Result := dir_path #+ sub_dir
			else
				Result := dir_path
			end
		end

feature {NONE} -- Constants

	Sub_app_dir: DIR_PATH
		-- sub-directory name derived from: `{EL_APPLICATION}.option_name'
		once ("PROCESS")
			create Result
		end

end