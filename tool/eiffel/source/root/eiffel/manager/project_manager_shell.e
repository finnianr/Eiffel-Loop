note
	description: "Project version manager shell command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-15 9:23:53 GMT (Tuesday 15th August 2023)"
	revision: "6"

class
	PROJECT_MANAGER_SHELL

inherit
	PROJECT_MANAGER_IMPLEMENTATION

	EL_LOGGABLE_CONSTANTS; FEATURE_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make
		do
			create scons.make
			create config.make_scons (scons)
			make_menu
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		local
			ecf_name, pecf_name, project_py: STRING
		do
			ecf_name := config.ecf_xml_path.base
			pecf_name := config.ecf_pyxis_path.base
			project_py := "project.py"

			create Result.make (<<
				["Edit " + project_py,				agent edit_file (project_py)],
				["Edit " + pecf_name,				agent edit_file (config.ecf_pyxis_path)],
				["Edit " + ecf_name,					agent edit_file (config.ecf_xml_path)],
				["Install F_code executable",		agent install_f_code_executable],
				["List feature code expansions",	agent list_feature_expansions],
				["Manage versions",					agent manage_versions],
				["Open cache directory",			agent open_directory (config.app_cache_path)],
				["Open configuration directory",	agent open_directory (config.app_configuration_path)],
				["Open data directory",				agent open_directory (config.app_data_path)],
				["Open project directory",			agent open_directory (Directory.current_working)],
				["Rename classes in source",		agent rename_source_classes],
				["Search classes in source",		agent regular_expression_search]
			>>)
		end

feature {NONE} -- Commands

	list_feature_expansions
		local
			code: ZSTRING
		do
			if attached Feature_expansion_table as table then
				lio.put_new_line
				from table.start until table.after loop
					code := table.key_for_iteration
					code.right_pad (' ', 3)
					lio.put_string (Expansion_template #$ [code])
					lio.set_text_color (Color.Red)
					lio.put_string ("feature ")
					lio.set_text_color (Color.Green)
					lio.put_string ("-- " + table.item_for_iteration)
					lio.set_text_color (Color.Default)
					lio.put_new_line
					table.forth
				end
				lio.put_new_line
			end
		end

	install_f_code_executable
		local
			install_command: EL_OS_COMMAND
		do
			create install_command.make_with_name (
				"ec_install_app", "python -m eiffel_loop.scripts.ec_install_app --f_code --install /usr/local/bin"
			)
			install_command.execute
		end

	manage_versions
		local
			shell: VERSION_MANAGER_SHELL_COMMAND
		do
			create shell.make (scons, config)
			shell.run_command_loop
		end

	regular_expression_search
		local
			shell: REGULAR_EXPRESSION_SEARCH_COMMAND
		do
			create shell.make (Directory.current_working + "source", Grep_results_path)
			shell.manifest.read_source_trees
			shell.execute
			Command.launch_gedit (Grep_results)
		end

	rename_source_classes
		local
			shell: CLASS_RENAMING_SHELL_COMMAND
		do
			create shell.make (Directory.current_working + "source")
			shell.run_command_loop
		end

feature {NONE} -- Implementation

	open_directory (path: DIR_PATH)
		do
			if path.exists and then attached Nautilus_command as cmd then
				cmd.set_path (path)
				cmd.execute
			else
				lio.put_path_field ("Cannot find %S", path)
				lio.put_new_line
			end
		end

feature {NONE} -- Constants

	Grep_results_path: FILE_PATH
		-- Find /home/finnian/Desktop/Eiffel Apps/grep_results.e
		once
			if attached OS.file_list (Directory.desktop, Grep_results) as path_list
				and then path_list.count = 1
			then
				Result := path_list.first_path
			else
				Result := Directory.desktop + Grep_results
			end
		end

	Grep_results: STRING = "grep_results.e"

	Expansion_template: ZSTRING
		once
			Result := "@f %S -> "
		end

end