note
	description: "Summary description for {EL_DIRECTORY_ROUTINES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-28 12:46:41 GMT (Sunday 28th June 2015)"
	revision: "4"

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
