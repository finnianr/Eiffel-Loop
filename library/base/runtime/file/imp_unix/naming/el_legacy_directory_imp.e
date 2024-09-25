note
	description: "A precursor to ${EL_STANDARD_DIRECTORY_IMP} prior to April 2020"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-25 11:17:12 GMT (Wednesday 25th September 2024)"
	revision: "9"

class
	EL_LEGACY_DIRECTORY_IMP

inherit
	EL_LEGACY_DIRECTORY_I

	EL_UNIX_IMPLEMENTATION

	EL_CHARACTER_32_CONSTANTS

feature {NONE} -- Constants

	Home: DIR_PATH
		-- returns `Home' or /home/root if user is root (useful for uninstaller)
		once
			create Result.make_expanded ("/home/$USER")
		end

	App_data: DIR_PATH
		once
			Result := Home.plus_dir (Relative_app_data)
		end

	App_configuration: DIR_PATH
		once
			Result := Home.joined_dir_tuple ([".config", Build_info.installation_sub_directory])
		end

	Relative_app_data: DIR_PATH
			--
		once
			Result := Dot + Build_info.installation_sub_directory.to_string
		end

end