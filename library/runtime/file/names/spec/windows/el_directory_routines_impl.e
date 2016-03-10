note
	description: "Summary description for {EL_DIRECTORY_ROUTINES_IMPL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_DIRECTORY_ROUTINES_IMPL

inherit
	EL_PLATFORM_IMPL

	EL_MS_WINDOWS_DIRECTORIES
		rename
			Program_files_dir as applications,
			System_dir as System_command,
			User_profile_dir as User_profile
		export
			{NONE} all
			{ANY} applications, System_command, User_profile, Desktop, Desktop_common
		end

	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_BUILD_INFO

create
	make

feature -- Access

	User_data_steps: EL_PATH_STEPS
			--
		once
			Result := Build_info.installation_sub_directory
		end

end
