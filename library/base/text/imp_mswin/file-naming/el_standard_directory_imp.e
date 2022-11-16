note
	description: "Windows implementation of [$source EL_STANDARD_DIRECTORY_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_STANDARD_DIRECTORY_IMP

inherit
	EL_STANDARD_DIRECTORY_I
		rename
			Home_directory_path as App_data_local -- Counter intuitive path from EXECUTION_ENVIRONMENT
		end

	EL_OS_IMPLEMENTATION

	EL_MS_WINDOWS_DIRECTORIES
		rename
			environ as environ_table,
			item as environ,
			My_documents as Documents,
			Home_directory_path as App_data_local, -- Counter intuitive path from EXECUTION_ENVIRONMENT
			Program_files_dir as Applications,
			System_dir as System_command,
			User_profile_dir as User_profile
		export
			{NONE} all
			{ANY} applications, System_command, User_profile, Desktop, Desktop_common
		end

feature -- Access

	Home: DIR_PATH
		once
			Result := environ ("HOMEDRIVE") + environ ("HOMEPATH")
		end

	User_local: DIR_PATH
		-- Windows 7: C:\Users\$USERNAME\AppData\Local
		once
			Result := App_data_local
		end

end