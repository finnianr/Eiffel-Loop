note
	description: "Unix implementation of [$source EL_STANDARD_DIRECTORY_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_STANDARD_DIRECTORY_IMP

inherit
	EL_STANDARD_DIRECTORY_I

	EL_OS_IMPLEMENTATION

feature -- Access

	Adapted_home: EL_DIR_PATH
		-- returns `Home' or /home/root if user is root (useful for uninstaller)
		once
			Result := Home
			if Result.step_count = 2 then
				Result := "/home/root"
			end
		end

	App_data: EL_DIR_PATH
		once
			Result := Adapted_home.joined_dir_path (Relative_app_data)
		end

	Applications: EL_DIR_PATH
		once
			Result := "/opt"
		end

	Configuration: EL_DIR_PATH
		once
			Result := Adapted_home.joined_dir_path (".config")
		end

	Documents: EL_DIR_PATH
		once
			Result := Home.joined_dir_path ("Documents")
		end

	Desktop: EL_DIR_PATH
		once
			Result := Home.joined_dir_path ("Desktop")
		end

	Home: EL_DIR_PATH
		once
			Result := environ ("HOME")
		end

	Desktop_common: EL_DIR_PATH
		once
			Result := Desktop
		end

	user_local: EL_DIR_PATH
		once
			Result := Home.joined_dir_path (".local/share")
		end

	Users: EL_DIR_PATH
		once
			Result := "/home"
		end

	Relative_app_data: EL_DIR_PATH
			--
		once
			Result := Execution.Data_dir_name_prefix + Build_info.installation_sub_directory.to_string
		end

	System_command: EL_DIR_PATH
		once
			Result := "/usr/bin"
		end

end
