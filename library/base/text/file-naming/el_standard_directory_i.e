note
	description: "[
		Platform independent interface to standard OS directories accessible via [$source EL_MODULE_DIRECTORY]
	]"
	notes: "[
		**Gnome Convention**
		
		This class follows the Gnome convention of locating:	

		* user data in `~/.local/share' (accessible via `Directory.app_data')
		* configuration in `~/.config' (accessible via `Directory.configuration')
		* non-essential data files in `~/.cache' (accessible via `Directory.cache')
		
		**MS Windows**
		
		For windows these directories are mapped to equivalent directories
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-19 10:10:39 GMT (Sunday 19th April 2020)"
	revision: "13"

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

	separator: CHARACTER
		do
			Result := Operating_environment.Directory_separator
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

	relative_app_data: EL_DIR_PATH
			-- path to application data files relative to user profile directory
		deferred
		end

feature -- Paths

	app_data: EL_DIR_PATH
		-- user application data
		deferred
		end

	applications: EL_DIR_PATH
			-- In Windows this is "Program Files"
		deferred
		end

	configuration: EL_DIR_PATH
		-- application configuration data
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
		-- For windows this is something like C:\Users\xxxx\AppData\Local
		-- For Linux: /home/xxxx/.local/share
		deferred
		end

	users: EL_DIR_PATH
		-- For windows 7: C:\Users
		-- For Linux: /home
		deferred
		end

	working, current_working: EL_DIR_PATH
		do
			create Result.make_from_path (current_working_path)
		end

feature -- Path constants

	Application_bin: EL_DIR_PATH
			-- Installed application executable directory
		once
			Result := application_installation.joined_dir_path ("bin")
		end

	Application_installation: EL_DIR_PATH
		once
			Result := applications.joined_dir_path (Build_info.installation_sub_directory)
		end

	App_configuration: EL_DIR_PATH
		once
			Result := configuration.joined_dir_path (Build_info.installation_sub_directory)
		end

feature -- Constants

	Parent: ZSTRING
		once
			Result := "/.."
		end

end
