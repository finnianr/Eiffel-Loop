note
	description: "[
		Platform independent interface to standard OS directories
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-05 13:01:49 GMT (Tuesday 5th July 2016)"
	revision: "1"

deferred class
	EL_STANDARD_DIRECTORY_I

inherit
	EXECUTION_ENVIRONMENT
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

feature -- Factory

	new_path (a_path: READABLE_STRING_GENERAL): EL_DIR_PATH
		do
			create Result.make_from_unicode (a_path.as_string_32)
		end

feature -- Access

	separator: CHARACTER
		do
			Result := operating_environment.Directory_separator
		end

	relative_parent (step_count: INTEGER): STRING
			-- parent relative to current using '../'
			-- Returns '.' if `step_count' = 0
			-- Returns '../' if `step_count' = 1
			-- Returns '../../' if `step_count' = 2
			-- and so forth
		do
			if step_count = 0 then
				Result := "."
			else
				Result := Parent.twin
				Result.multiply (step_count)
				Result.remove_head (1)
			end
		end

feature -- Paths

	applications: EL_DIR_PATH
			-- In Windows this is "Program Files"
		deferred
		end

	configuration_dir_for_user (name: ZSTRING): EL_DIR_PATH
			-- `User_configuration' directory for user `name'
		do
			Result := named_user_dir (name, User_configuration)
		end

	data_dir_for_user (name: ZSTRING): EL_DIR_PATH
			-- `User_data' directory for user `name'
		do
			Result := named_user_dir (name, User_data)
		end

	desktop: EL_DIR_PATH
		deferred
		end

	desktop_common: EL_DIR_PATH
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

	user, user_profile: EL_DIR_PATH
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

	Home: EL_DIR_PATH
		once
			create Result.make_from_path (Home_directory_path)
		end

	User_configuration: EL_DIR_PATH
		once
			Result := home.joined_dir_path (User_configuration_steps)
		end

	User_data: EL_DIR_PATH
		once
			Result := home.joined_dir_path (user_data_steps)
		end

feature {NONE} -- Implementation

	named_user_dir (name: ZSTRING; user_dir: EL_DIR_PATH): EL_DIR_PATH
		local
			steps: EL_PATH_STEPS
		do
			steps := user_profile; steps.last.share (name)
			Result := steps.as_directory_path.joined_dir_path (user_dir.relative_path (user_profile))
		end

	user_data_steps: EL_PATH_STEPS
			--
		deferred
		end

feature {NONE} -- Constants

	User_configuration_steps: EL_PATH_STEPS
		once
			Result := Build_info.installation_sub_directory
			Result.put_front (Execution.user_configuration_directory_name)
		end

feature -- Constants

	Parent: STRING = "/.."

end
