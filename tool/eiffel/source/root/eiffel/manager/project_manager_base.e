note
	description: "Common routines for ${PROJECT_MANAGER_SHELL} and ${VERSION_MANAGER_SHELL_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-14 8:50:01 GMT (Monday 14th April 2025)"
	revision: "8"

deferred class
	PROJECT_MANAGER_BASE

inherit
	EL_COMMAND_SHELL_I
		rename
			make as make_shell
		end

	EL_STRING_GENERAL_ROUTINES_I

	EL_MODULE_COMMAND; EL_MODULE_DIRECTORY; EL_MODULE_OS; EL_MODULE_USER_INPUT

feature {NONE} -- Initialization

	make_menu
		local
			title: STRING
		do
			title := super_8 (generator).substring_to ('_')
			make_shell (Menu_template #$ [title, config.ecf_pyxis_path.base], 10)
		end

feature {NONE} -- Implementation

	edit_file (path: FILE_PATH)
		do
			if path.exists then
				Command.launch_gedit (path)
			else
				lio.put_path_field ("Cannot find %S", path)
				lio.put_new_line
			end
		end

feature {NONE} -- Internal attributes

	config: PYXIS_EIFFEL_CONFIG

	scons: SCONS_PROJECT_PY_CONFIG

feature {NONE} -- Constants

	Menu_template: ZSTRING
		once
			Result := "%S MENU (%S)"
		end

	Nautilus_command: EL_FILE_UTILITY_COMMAND
		once
			Result := "nautilus"
		end

end