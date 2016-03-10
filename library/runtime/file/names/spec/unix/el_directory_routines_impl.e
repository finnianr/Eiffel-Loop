note
	description: "Summary description for {EL_DIRECTORY_ROUTINES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-09 18:01:48 GMT (Thursday 9th July 2015)"
	revision: "4"

class
	EL_DIRECTORY_ROUTINES_IMPL

inherit
	EL_PLATFORM_IMPL

	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_BUILD_INFO

create
	make

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

	User_profile: EL_DIR_PATH
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
