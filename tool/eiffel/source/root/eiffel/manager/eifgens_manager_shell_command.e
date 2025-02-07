note
	description: "EIFGENs directory manager shell command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-07 16:57:41 GMT (Friday 7th February 2025)"
	revision: "4"

class
	EIFGENS_MANAGER_SHELL_COMMAND

inherit
	PROJECT_MANAGER_BASE

	EL_ITERATION_OUTPUT

	EL_SET [CHARACTER_8]
		rename
			has as is_eiffel_c_name_character
		end

	EL_MODULE_FILE

	CROSS_PLATFORM_CONSTANTS; EL_CHARACTER_8_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_scons: like scons; a_config: like config)
		do
			scons := a_scons; config := a_config
			make_menu
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make_assignments (<<
				["Copy F_code executable to package",	  agent copy_f_code_executable],
				["Install F_code executable",				  agent install_f_code_executable],
				["Put Eiffel names in workarea/gdb.txt", agent lookup_gdb_functions],
				["Remove EIFGENs directory",				  agent remove_eifgens]
			>>)
		end

feature {NONE} -- Commands

	copy_f_code_executable
		-- copy to package
		do
			OS.copy_file (F_code_dir + config.executable_name_full, Package_bin_dir)
			lio.put_labeled_string ("Copied", config.executable_name_full + " to package/bin" )
			lio.put_new_line_x2
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

	remove_eifgens
		local
			target_dir: DIR_PATH; count: INTEGER
		do
			across Platform_list as list loop
				target_dir := EIFGENs_path_template #$ [list.item]
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

feature {NONE} -- Implementation

	is_eiffel_c_name (name: STRING): BOOLEAN
		-- `True' if `name' is something like "F2009_11721"
		local
			s: EL_STRING_8_ROUTINES
		do
			if s.starts_with_character (name, 'F') and then name.occurrences ('_') = 1 then
				Result := s.is_subset_of (name, Current) -- `is_eiffel_c_name_character'
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
				create Result.make (5000)
				internal_eiffel_name_table := Result

				comment_end := " */"
				across OS.file_list (F_code_dir, "*.c") as src loop
					print_progress (src.cursor_index.to_natural_32)
					source := File.plain_text (src.item)
					if attached s.occurrence_intervals (source, "/* {", False) as list then
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

feature {NONE} -- Internal attributes

	internal_eiffel_name_table: detachable like new_eiffel_name_table

feature {NONE} -- Constants

	Iterations_per_dot: NATURAL_32 = 10

end