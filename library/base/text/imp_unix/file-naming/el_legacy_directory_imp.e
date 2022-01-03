note
	description: "A precursor to [$source EL_STANDARD_DIRECTORY_IMP] prior to April 2020"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:51 GMT (Monday 3rd January 2022)"
	revision: "2"

class
	EL_LEGACY_DIRECTORY_IMP

inherit
	EL_LEGACY_DIRECTORY_I

	EL_OS_IMPLEMENTATION

feature {NONE} -- Constants

	Home: DIR_PATH
		-- returns `Home' or /home/root if user is root (useful for uninstaller)
		once
			Result := "/home/$USER"
			Result.expand
		end

	App_data: DIR_PATH
		once
			Result := Home.joined_dir_path (Relative_app_data)
		end

	App_configuration: DIR_PATH
		once
			Result := Home.joined_dir_tuple ([".config", Build_info.installation_sub_directory])
		end

	Relative_app_data: DIR_PATH
			--
		once
			Result := Data_dir_name_prefix + Build_info.installation_sub_directory.to_string
		end

	Data_dir_name_prefix: ZSTRING
		once
			Result := "."
		end

end
