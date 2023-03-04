note
	description: "Project version manager shell command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-04 16:28:25 GMT (Saturday 4th March 2023)"
	revision: "1"

class
	VERSION_MANAGER_SHELL_COMMAND

inherit
	EL_COMMAND_SHELL_I
		rename
			make as make_shell
		redefine
			display_menu
		end

	EL_MODULE_COMMAND

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make
		do
			make_shell ("VERSION MENU", 10)
			create scons.make
			create config.make_scons (scons)
			previous_version := config.system.version
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Bump major number",	agent do do_bump (agent {EL_SOFTWARE_VERSION}.bump_major) end],
				["Bump minor number",	agent do do_bump (agent {EL_SOFTWARE_VERSION}.bump_minor) end],
				["Bump release number",	agent do do_bump (agent {EL_SOFTWARE_VERSION}.bump_release) end],
				["Revert to previous",	agent do config.set_version (previous_version) end],
				["Edit version notes",	agent edit_versions]
			>>)
		end

feature {NONE} -- Implementation

	display_menu
		do
			lio.put_labeled_string ("Project", scons.ecf)
			lio.put_new_line
			lio.put_labeled_string ("Previous version", previous_version.string)
			lio.put_new_line
			lio.put_labeled_string ("Current version", config.system.version.string)
			lio.put_new_line_x2
			menu.display
		end

	do_bump (bump: PROCEDURE [EL_SOFTWARE_VERSION])
		local
			new_version: like previous_version
		do
			previous_version := config.system.version
			new_version := config.system.version
			bump (new_version)
			config.set_version (new_version)
		end

	edit_versions
		do
			if Versions_text_path.exists then
				Command.launch_gedit (Versions_text_path)
			else
				lio.put_path_field ("Cannot find file %S", Versions_text_path)
				lio.put_new_line
			end
		end

feature {NONE} -- Internal attributes

	config: PYXIS_EIFFEL_CONFIG

	previous_version: EL_SOFTWARE_VERSION

	scons: SCONS_PROJECT_PY_CONFIG

feature {NONE} -- Constants

	Versions_text_path: FILE_PATH
		once
			Result := "doc/versions.txt"
		end

end