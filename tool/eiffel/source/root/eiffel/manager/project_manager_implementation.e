note
	description: "Common routines for ${PROJECT_MANAGER_SHELL} and ${VERSION_MANAGER_SHELL_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-23 8:47:14 GMT (Saturday 23rd March 2024)"
	revision: "6"

deferred class
	PROJECT_MANAGER_IMPLEMENTATION

inherit
	EL_COMMAND_SHELL_I
		rename
			make as make_shell
		end

	EL_MODULE_COMMAND; EL_MODULE_DIRECTORY; EL_MODULE_OS; EL_MODULE_USER_INPUT

feature {NONE} -- Initialization

	make_menu
		local
			title: STRING; s: EL_STRING_8_ROUTINES
		do
			title := s.substring_to (generator, '_')
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