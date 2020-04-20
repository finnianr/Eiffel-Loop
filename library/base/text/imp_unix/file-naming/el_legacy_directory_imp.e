note
	description: "A precursor to [$source EL_STANDARD_DIRECTORY_IMP] prior to April 2020"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-19 13:02:27 GMT (Sunday 19th April 2020)"
	revision: "1"

class
	EL_LEGACY_DIRECTORY_IMP

inherit
	EL_LEGACY_DIRECTORY_I

	EL_OS_IMPLEMENTATION

feature {NONE} -- Constants

	Home: EL_DIR_PATH
		-- returns `Home' or /home/root if user is root (useful for uninstaller)
		once
			Result := "/home/$USER"
			Result.expand
		end

	App_data: EL_DIR_PATH
		once
			Result := Home.joined_dir_path (Relative_app_data)
		end

	App_configuration: EL_DIR_PATH
		once
			Result := Home.joined_dir_tuple ([".config", Build_info.installation_sub_directory])
		end

	Relative_app_data: EL_DIR_PATH
			--
		once
			Result := Data_dir_name_prefix + Build_info.installation_sub_directory.to_string
		end

	Data_dir_name_prefix: ZSTRING
		once
			Result := "."
		end

end
