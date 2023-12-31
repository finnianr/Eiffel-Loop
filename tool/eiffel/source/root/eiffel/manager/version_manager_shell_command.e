note
	description: "Project version manager shell command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-31 9:31:03 GMT (Sunday 31st December 2023)"
	revision: "4"

class
	VERSION_MANAGER_SHELL_COMMAND

inherit
	PROJECT_MANAGER_IMPLEMENTATION
		redefine
			display_menu
		end

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_scons: like scons; a_config: like config)
		do
			scons := a_scons; config := a_config
			make_menu
			previous_version := config.system.version
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Bump major number",			 agent do do_bump (agent {EL_SOFTWARE_VERSION}.bump_major) end],
				["Bump minor number",			 agent do do_bump (agent {EL_SOFTWARE_VERSION}.bump_minor) end],
				["Bump release number",			 agent do do_bump (agent {EL_SOFTWARE_VERSION}.bump_release) end],
				["Delete installed versions",	 agent delete_installed_versions],
				["Edit version notes",			 agent edit_file (Versions_text_path)],
				["List installed versions",	 agent list_installed_versions],
				["Revert to previous version", agent do config.set_version (previous_version) end]
			>>)
		end

feature {NONE} -- Commands

	delete_installed_versions
		do
			installed_executable_list.delete_range (config.executable_name)
		end

	list_installed_versions
		do
			installed_executable_list.display_versions (config.executable_name)
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

	installed_executable_list: EL_VERSION_PATH_LIST
		do
			if attached config.usr_local_executable_path as path then
				create Result.make (path.parent, path.base + "*")
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Internal attributes

	previous_version: EL_SOFTWARE_VERSION

feature {NONE} -- Constants

	Versions_text_path: FILE_PATH
		once
			Result := "doc/versions.txt"
		end

end