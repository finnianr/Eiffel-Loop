note
	description: "Windows implementation of [$source EL_STANDARD_DIRECTORY_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-29 9:08:28 GMT (Friday 29th June 2018)"
	revision: "4"

class
	EL_STANDARD_DIRECTORY_IMP

inherit
	EL_STANDARD_DIRECTORY_I

	EL_OS_IMPLEMENTATION

	EL_MS_WINDOWS_DIRECTORIES
		rename
			environ as environ_table,
			item as environ,
			My_documents as Documents,
			Program_files_dir as Applications,
			System_dir as System_command,
			User_profile_dir as User_profile
		export
			{NONE} all
			{ANY} applications, System_command, User_profile, Desktop, Desktop_common
		end

feature -- Access

	App_data: EL_DIR_PATH
		once
			Result := User_local.joined_dir_path (Relative_app_data)
		end

	Configuration: EL_DIR_PATH
		once
			Result := User_local.joined_dir_path ("config")
		end

	Home: EL_DIR_PATH
		once
			Result := environ ("HOMEDRIVE") + environ ("HOMEPATH")
		end

	User_local: EL_DIR_PATH
		-- Windows 7: C:\Users\xxxx\AppData\Local
		once
			Result := Home_directory_path -- Counter intuitive path from EXECUTION_ENVIRONMENT
		end

	Users: EL_DIR_PATH
		once
			Result := Home.parent
		end

	Relative_app_data: EL_DIR_PATH
			--
		once
			Result := Build_info.installation_sub_directory
		end

end
