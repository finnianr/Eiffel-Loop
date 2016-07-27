note
	description: "Windows implementation of `EL_STANDARD_DIRECTORY_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 15:25:51 GMT (Thursday 7th July 2016)"
	revision: "5"

class
	EL_STANDARD_DIRECTORY_IMP

inherit
	EL_STANDARD_DIRECTORY_I

	EL_OS_IMPLEMENTATION

	EL_MS_WINDOWS_DIRECTORIES
		rename
			Program_files_dir as applications,
			System_dir as System_command,
			User_profile_dir as User_profile
		export
			{NONE} all
			{ANY} applications, System_command, User_profile, Desktop, Desktop_common
		end

feature -- Access

	User_data_steps: EL_PATH_STEPS
			--
		once
			Result := Build_info.installation_sub_directory
		end

end