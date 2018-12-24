note
	description: "Platform independent interface to standard OS directories"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-23 23:24:52 GMT (Sunday 23rd December 2018)"
	revision: "7"

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
		export
			{NONE} all
		end

	EL_MODULE_ENVIRONMENT
		export
			{NONE} all
		end

	EL_MODULE_BUILD_INFO
		export
			{NONE} all
		end

	EL_ZSTRING_CONSTANTS

feature -- Factory

	new_path (a_path: READABLE_STRING_GENERAL): EL_DIR_PATH
		do
			create Result.make_from_general (a_path.as_string_32)
		end

feature -- Access

	separator: CHARACTER
		do
			Result := operating_environment.Directory_separator
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
		deferred
		end

	applications: EL_DIR_PATH
			-- In Windows this is "Program Files"
		deferred
		end

	configuration: EL_DIR_PATH
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
