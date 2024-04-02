note
	description: "[
		Command to output a "descendants" note field for copy/pasting into Eiffel source code.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-02 8:45:07 GMT (Tuesday 2nd April 2024)"
	revision: "35"

class
	CLASS_DESCENDANTS_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_REFLECTIVE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_COMMAND; EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO; EL_MODULE_OS

	EL_CHARACTER_32_CONSTANTS; EL_EIFFEL_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_build_dir, a_output_dir: DIR_PATH; a_class_name: STRING; a_target_name: ZSTRING)
		local
			descendats: ZSTRING
		do
			make_machine

			build_dir := a_build_dir; output_dir := a_output_dir; class_name := a_class_name
			target_name := a_target_name
			create ecf_path
			output_path := output_dir + (a_class_name + ".txt")
			descendats := "Descendants-"
			output_path.set_base (descendats + output_path.base)

			if output_path.exists then
				File_system.remove_file (output_path)
			end
			set_ecf_path_from_target
		end

feature -- Constants

	Description: STRING = "Output descendants of class to a file with wiki-markup"

feature -- Basic operations

	execute
		do
			if ecf_path.is_empty then
				lio.put_string_field ("ERROR: Cannot find ECF file with target", target_name)
				lio.put_new_line
			else
				lio.put_path_field ("Writing %S", output_path)
				lio.put_new_line
				if not output_dir.exists then
					File_system.make_directory (output_dir)
				end
				Descendants_command.put_object (Current)
				Descendants_command.execute
				reformat_output
				lio.put_line ("DONE")

				Command.launch_gedit (output_path)
			end
		end

feature {NONE} -- Line states

	find_target_name (line: ZSTRING; a_ecf_path: FILE_PATH)
		local
			l_target_name: ZSTRING
		do
			if line.begins_with (Element_target_name) then
				l_target_name := line.substring_between (char ('"'), char ('"'), 1).as_lower
				if l_target_name ~ target_name then
					ecf_path := a_ecf_path
				end
				state := final
			end
		end

feature {NONE} -- Implementation

	expand_links (line: ZSTRING; tab_count: INTEGER; is_first_line: BOOLEAN)
		-- Change for example: EL_DESCRIPTIVE_ENUMERATION* [N -> {NUMERIC, HASHABLE}]
		-- to: ${EL_DESCRIPTIVE_ENUMERATION* [N -> (NUMERIC, HASHABLE)]}
		local
			eif: EL_EIFFEL_SOURCE_ROUTINES; index: INTEGER
		do
			line.prune_all_trailing ('.') -- remove ellipsis "..." on last line
			line.translate ("{}", "()") -- change:  [N -> {NUMERIC, HASHABLE}]
			line.insert_string (Dollor_left_brace, tab_count + 1)
			line.append_character ('}')

			if is_first_line then
			-- First line is current class so we make a change like this:
			-- 	EL_STRING_EDITOR [S -> ${STRING_GENERAL} create make end]*
				eif.enclose_class_parameters (line)
				across << Dollor_left_brace, char ('}') * 1 >> as str loop
					index := line.substring_index (str.item, 1)
					if index > 0 then
						line.remove_substring (index, index + str.item.count - 1)
					end
				end
			end
		end

	reformat_output
		local
			tab_count, count: INTEGER; line: ZSTRING
		do
			if attached File.plain_text_lines (output_path) as text_lines
				and then attached open (output_path, Write) as file_out
			then
				file_out.put_lines (<<
					"note",
					"%Tdescendants: %"See end of class%"",
					"%Tdescendants: %"["
				>>)
				file_out.put_new_line
				across text_lines as text loop
					line := text.item
					tab_count := line.leading_occurrences ('%T')
					if line.count > tab_count then
						count := count + 1
						expand_links (line, tab_count, count = 1)
						file_out.put_string_8 ("%T%T")
						file_out.put_string (line)
						file_out.put_new_line
					end
				end
				file_out.put_string_8 ("%T]%"")
				file_out.close
			end
		end

	set_ecf_path_from_target
		do
			if attached OS.find_files_command (Directory.current_working, "*.ecf") as cmd then
				cmd.set_max_depth (1)
				cmd.execute

				across cmd.path_list as path until not ecf_path.is_empty loop
					do_once_with_file_lines (agent find_target_name (?, path.item), open_lines (path.item, Latin_1))
				end
			end
		end

feature {NONE} -- Internal attributes

	build_dir: DIR_PATH

	class_name: STRING

	ecf_path: FILE_PATH

	output_dir: DIR_PATH

	output_path: FILE_PATH

	target_name: ZSTRING

feature {NONE} -- Constants

	Descendants_command: EL_OS_COMMAND
		once
			create Result.make_with_name (
				"descendants",
				"ec -descendants $class_name -project_path $build_dir -config $ecf_path -file $output_path"
			)
		end

	Element_target_name: ZSTRING
		once
			Result := "<target name"
		end

end