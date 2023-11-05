note
	description: "A precursor to [$source EL_STANDARD_DIRECTORY_IMP] prior to April 2020"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:14:00 GMT (Sunday 5th November 2023)"
	revision: "5"

class
	EL_LEGACY_DIRECTORY_IMP

inherit
	EL_LEGACY_DIRECTORY_I

	EL_WINDOWS_IMPLEMENTATION

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

	App_data: DIR_PATH
		once
			Result := User_local #+ Relative_app_data
		end

	App_configuration: DIR_PATH
		once
			Result := User_local.joined_dir_tuple (["config", Relative_app_data])
		end

	User_local: DIR_PATH
		-- Windows 7: C:\Users\xxxx\AppData\Local
		once
			Result := Home_directory_path -- Counter intuitive path from EXECUTION_ENVIRONMENT
		end

	Relative_app_data: DIR_PATH
			--
		once
			Result := Build_info.installation_sub_directory
		end

end