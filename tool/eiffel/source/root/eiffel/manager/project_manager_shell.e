note
	description: "Project version manager shell command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-31 11:13:16 GMT (Wednesday 31st January 2024)"
	revision: "14"

class
	PROJECT_MANAGER_SHELL

inherit
	PROJECT_MANAGER_IMPLEMENTATION

	EL_ITERATION_OUTPUT

	EL_MODULE_COMMAND; EL_MODULE_FILE

	EL_LOGGABLE_CONSTANTS; EL_ZSTRING_CONSTANTS; EL_CHARACTER_8_CONSTANTS

	FEATURE_CONSTANTS; CROSS_PLATFORM_CONSTANTS

	EL_SET [CHARACTER_8]
		rename
			has as is_eiffel_c_name_character
		end

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
				["Edit " + project_py,						  agent edit_file (project_py)],
				["Edit " + pecf_name,						  agent edit_file (config.ecf_pyxis_path)],
				["Edit " + ecf_name,							  agent edit_file (config.ecf_xml_path)],
				["Install F_code executable",				  agent install_f_code_executable],
				["List feature code expansions",			  agent list_feature_expansions],
				["Manage versions",							  agent manage_versions],
				["Open cache directory",					  agent open_directory (config.app_cache_path)],
				["Open configuration directory",			  agent open_directory (config.app_configuration_path)],
				["Open data directory",						  agent open_directory (config.app_data_path)],
				["Open project directory",					  agent open_directory (Directory.current_working)],
				["Put Eiffel names in workarea/gdb.txt", agent lookup_gdb_functions],
				["Remove EIFGENs directory",				  agent remove_eifgens],
				["Rename classes in source",				  agent rename_source_classes],
				["Search classes in source",				  agent regular_expression_search]
			>>)
			if Default_localization_manifest.exists then
				Result ["Update " + Locale_resources_dir.to_string_8] := agent update_locale_resources
			end
		end

feature {NONE} -- Commands

	install_f_code_executable
		local
			install_command: EL_OS_COMMAND
		do
			create install_command.make_with_name (
				"ec_install_app", "python -m eiffel_loop.scripts.ec_install_app --f_code --install /usr/local/bin"
			)
			install_command.execute
		end

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

	lookup_gdb_functions
		-- replace pointer with Eiffel name for gdb stacktrace in workarea/gdb.txt
		-- #7  0x0000000000fb0f21 in F2009_11721 ()
		--	#8  0x0000000000a15a1b in F3252_38179 ()
		local
			f_marker_index: INTEGER; s: EL_STRING_8_ROUTINES; gdb_txt_path: FILE_PATH
			f_marker, line, f_name: STRING
		do
			gdb_txt_path := "workarea/gdb.txt"; f_marker := " F"

			if gdb_txt_path.exists then
				lio.put_line ("Creating Eiffel function lookup table from F_code *.c")
				if attached new_eiffel_name_table as name_table then
					across File.plain_text_lines (gdb_txt_path) as list loop
						line := list.item_copy
						if line.count > 25 then
							line.remove_substring (4, 25) -- remove pointer address
							f_marker_index := line.substring_index (f_marker, 1)
							if f_marker_index > 0 then
								f_marker_index := f_marker_index + f_marker.count - 1
								f_name := s.substring_to_from (line, ' ', $f_marker_index)
								if name_table.has_key (f_name) then
									line.remove_tail (2)
									if line.count < 16 then
										line.append (space * (16 - line.count))
									end
									line.append_string_general ("-> ")
									line.append (name_table.found_item)
								end
							end
						end
						lio.put_line (line)
					end
				end
			else
				lio.put_path_field ("Save stacktrace from gdb in %S", gdb_txt_path)
				lio.put_new_line
			end
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
			shell.read_manifest_files
			shell.execute
		end

	remove_eifgens
		local
			target_dir: DIR_PATH; count: INTEGER
		do
			across Platform_list as list loop
				target_dir := Eifgens_dir #$ [list.item]
				if target_dir.exists then
					count := count + 1
					lio.put_labeled_string ("Remove", target_dir.to_string)
					lio.put_new_line
					if User_input.approved_action_y_n ("Are you sure ?") then
						OS.delete_tree (target_dir)
						lio.put_line ("Removed")
					end
				end
			end
			if count = 0 then
				lio.put_line ("No EIFGENs directory found for any ISE platform")
			end
		end

	rename_source_classes
		local
			shell: CLASS_RENAMING_SHELL_COMMAND
		do
			create shell.make (Directory.current_working + "source")
			shell.run_command_loop
		end

	update_locale_resources
		local
			compiler: PYXIS_TRANSLATION_TREE_COMPILER
		do
			create compiler.make (Default_localization_manifest, Empty_string, Locale_resources_dir)
			compiler.execute
			if compiler.is_updated
				and then attached Command.new_copy_tree (Locale_resources_dir, config.app_installation_path) as install
			then
				lio.put_line ("Installing updated localization files")
				install.sudo.enable
				install.execute
			end
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	internal_eiffel_name_table: detachable like new_eiffel_name_table

feature {NONE} -- Implementation

	is_eiffel_c_name (name: STRING): BOOLEAN
		-- `True' if `name' is something like "F2009_11721"
		local
			s: EL_STRING_8_ROUTINES
		do
			if s.starts_with_character (name, 'F') and then name.occurrences ('_') = 1 then
				Result := s.has_only (name, Current) -- `is_eiffel_c_name_character'
			end
		end

	is_eiffel_c_name_character (c: CHARACTER): BOOLEAN
		do
			inspect c
				when '0' .. '9', '_', 'F' then
					Result := True
			else
			end
		end

	new_eiffel_name_table: EL_HASH_TABLE [STRING, STRING]
		-- Code example 1:
		-- 	EIF_REFERENCE F2009_11721 (EIF_REFERENCE Current)

		-- Code example 2:
		-- 	static EIF_REFERENCE F2009_11721 (EIF_REFERENCE Current)

		-- Code example 3:
		-- 	/* {EL_APPLICATION}.do_application */
		-- 	#undef EIF_VOLATILE
		-- 	#define EIF_VOLATILE volatile
		-- 	void F3291_32332 (EIF_REFERENCE Current)

		local
			s: EL_STRING_8_ROUTINES; function_name, c_name, comment_end, source: STRING
			end_index, c_name_index: INTEGER; found: BOOLEAN
		do
			if attached internal_eiffel_name_table as table then
				Result := table
			else
				create Result.make_size (5000)
				internal_eiffel_name_table := Result
				
				comment_end := " */"
				across OS.file_list (F_code_dir, "*.c") as src loop
					print_progress (src.cursor_index.to_natural_32)
					source := File.plain_text (src.item)
					if attached s.occurrence_intervals (source, "/* {") as list then
						from list.start until list.after loop
							end_index := source.substring_index (comment_end, list.item_upper + 1)
							if end_index > 0 then
								function_name := source.substring (list.item_upper + 1, end_index - 1)
								function_name.prune ('}')
								c_name_index := end_index + comment_end.count
								from found := False until found loop
									c_name := s.substring_to_from (source, ' ', $c_name_index)
									if is_eiffel_c_name (c_name) then
										Result.extend (function_name, c_name)
										found := True
									end
								end
							end
							list.forth
						end
					end
				end
				lio.put_new_line
			end
		end

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

	Default_localization_manifest: FILE_PATH
		once
			Result := "localization/manifest.pyx"
		end

	Expansion_template: ZSTRING
		once
			Result := "@f %S -> "
		end

	Grep_results: STRING = "grep_results.e"

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

	Iterations_per_dot: NATURAL_32 = 10

	Locale_resources_dir: ZSTRING
		once
			Result := "resources/locales"
		end

end