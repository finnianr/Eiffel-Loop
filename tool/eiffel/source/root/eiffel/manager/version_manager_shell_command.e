note
	description: "Project version manager shell command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-23 13:10:28 GMT (Sunday 23rd July 2023)"
	revision: "2"

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
		local
			count: INTEGER; range: INTEGER_INTERVAL; name_parts: EL_STRING_8_LIST
			input: EL_USER_INPUT_VALUE [INTEGER]; version_path, executable_path: FILE_PATH
		do
			list_installed_versions

			executable_path := config.usr_local_executable_path
			if attached new_installed_versions as version_list then
				range := 0 |..| Versions_text_path.count
				create input.make_valid ("Enter number to delete from earliest", "Invalid number", agent range.has)
				count := input.value
				across version_list as list until list.cursor_index > count loop
					create name_parts.make_from_array (<< executable_path.base, list.item.string>>)
					version_path := executable_path.parent + name_parts.joined ('-')
					lio.put_path_field ("Delete", version_path)
					if User_input.approved_action_y_n ("")
						and then attached command.new_delete_file (version_path) as cmd
					then
						cmd.sudo.enable
						cmd.execute
						lio.put_line ("Deleted")
					else
						lio.put_line ("Skipped")
					end
				end
				lio.put_new_line
			end
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

	list_installed_versions
		local
			excutable_path: FILE_PATH
		do
			excutable_path := "/usr/local/bin/" + config.executable_name
			lio.put_new_line
			lio.put_path_field ("VERSIONS of " + config.executable_name + " in",  excutable_path.parent)
			lio.put_new_line
			if attached new_installed_versions as installed_list and then installed_list.count > 0 then
				across installed_list as version loop
					lio.put_index_labeled_string (version, Void, version.item.string)
					lio.put_new_line
				end
			else
				lio.put_line ("Nothing installed")
			end
			lio.put_new_line
		end

	new_installed_executable_list: EL_FILE_PATH_LIST
		do
			if attached config.usr_local_executable_path as excutable_path then
				Result := OS.file_list (excutable_path.parent, excutable_path.base + "*")
			else
				create Result.make_empty
			end
		end

	new_installed_versions: EL_ARRAYED_LIST [EL_SOFTWARE_VERSION]
		local
			version_str: STRING
		do
			if attached new_installed_executable_list as file_list then
				create Result.make (file_list.count)
				across file_list as path loop
					if attached path.item.base as name then
						version_str := name.substring_to_reversed ('-', default_pointer)
						if version_str.count < name.count then
							Result.extend (version_str)
						end
					end
				end
			end
			Result.sort (True)
		end

feature {NONE} -- Internal attributes

	previous_version: EL_SOFTWARE_VERSION

feature {NONE} -- Constants

	Versions_text_path: FILE_PATH
		once
			Result := "doc/versions.txt"
		end

end