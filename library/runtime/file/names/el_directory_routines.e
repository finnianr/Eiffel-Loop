note
	description: "Summary description for {EL_DIRECTORY_NAMING_ROUTINES_U8}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-02-07 12:33:33 GMT (Sunday 7th February 2016)"
	revision: "5"

class
	EL_DIRECTORY_ROUTINES

inherit
	EL_CROSS_PLATFORM [EL_DIRECTORY_ROUTINES_IMPL]
		rename
			make_default as make
		end

	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_ENVIRONMENT

	EL_MODULE_BUILD_INFO

create
	make

feature -- Factory

	path (a_path: READABLE_STRING_GENERAL): EL_DIR_PATH
		do
			create Result.make_from_unicode (a_path.as_string_32)
		end

feature -- Access

	separator: CHARACTER
		do
			Result := operating_environment.Directory_separator
		end

feature -- Paths

	applications: EL_DIR_PATH
			-- In Windows this is "Program Files"
		do
			Result := implementation.applications
		end

	system_command: EL_DIR_PATH
			--
		do
			Result :=  implementation.System_command
		end

	temporary: EL_DIR_PATH
		do
			Result := Environment.Operating.Temp_directory_path
		end

	user, user_profile: EL_DIR_PATH
		do
			Result := implementation.user_profile
		end

	working, current_working: EL_DIR_PATH
		do
			create Result.make_from_path (current_working_path)
		end

feature -- Constants paths

	Application_bin: EL_DIR_PATH
			-- Installed application executable directory
		once
			Result := application_installation.joined_dir_path ("bin")
		end

	Application_installation: EL_DIR_PATH
		once
			Result := applications.joined_dir_path (Build_info.installation_sub_directory)
		end

	Desktop: EL_DIR_PATH
		once
			Result := implementation.Desktop
		end

	Desktop_common: EL_DIR_PATH
		once
			Result := implementation.Desktop_common
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

	user_data_steps: EL_PATH_STEPS
			--
		do
			Result := implementation.user_data_steps
		end

feature {NONE} -- Constants

	User_configuration_steps: EL_PATH_STEPS
		once
			Result := Build_info.installation_sub_directory
			Result.put_front (Execution.user_configuration_directory_name)
		end

end
