note
	description: "Unix implementation of `EL_STANDARD_DIRECTORY_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 8:47:41 GMT (Friday 24th June 2016)"
	revision: "1"

class
	EL_STANDARD_DIRECTORY_IMP

inherit
	EL_STANDARD_DIRECTORY_I

	EL_OS_IMPLEMENTATION

feature -- Access

	Applications: EL_DIR_PATH
		once
			Result := "/opt"
		end

	Desktop: EL_DIR_PATH
		once
			Result := User_profile.joined_dir_path ("Desktop")
		end

	Desktop_common: EL_DIR_PATH
		once
			Result := Desktop
		end

	User, User_profile: EL_DIR_PATH
		once
			create Result.make_from_path (Home_directory_path)
		end

	User_data_steps: EL_PATH_STEPS
			--
		once
			Result := Build_info.installation_sub_directory
			Result.first.prepend (Execution.Data_dir_name_prefix)
		end

	System_command: EL_DIR_PATH
		once
			Result := "/usr/bin"
		end

end