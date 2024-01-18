note
	description: "[
		Command to output a "descendants" note field for copy/pasting into Eiffel source code.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-02 12:02:24 GMT (Thursday 2nd November 2023)"
	revision: "31"

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
				l_target_name := line.substring_between (Quote, Quote, 1).as_lower
				if l_target_name ~ target_name then
					ecf_path := a_ecf_path
				end
				state := final
			end
		end

feature {NONE} -- Implementation

	expand_constraint_list (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			constraint_list: EL_ZSTRING_LIST; expanded_string, word: ZSTRING
			eif: EL_EIFFEL_SOURCE_ROUTINES
		do
			create expanded_string.make (end_index - start_index + 1)
			create constraint_list.make_comma_split (substring.substring (start_index, end_index))
			across constraint_list as c_list loop
				word := c_list.item
				if not c_list.is_first then
					expanded_string.append_string_general (", ")
				end
				if eif.is_class_name (word) then
					expanded_string.append (Source_link_template #$ [word])
				end
			end
			substring.replace_substring (expanded_string, start_index, end_index)
		end

	expand_links (line: ZSTRING; tab_count: INTEGER)
		local
			word_list: EL_ZSTRING_LIST; word: ZSTRING
			last_character: CHARACTER_32; eif: EL_EIFFEL_SOURCE_ROUTINES
		do
			create word_list.make_word_split (line.substring_end (tab_count + 1))
			line.keep_head (tab_count)
			across word_list as list loop
				word := list.item
				if word.count > 0 then
					last_character := word [word.count]
					inspect last_character
						when '*', ']', ',' then
							do_nothing
					else
						last_character := '%U'
					end
				else
					last_character := '%U'
				end
				if last_character.code.to_boolean then
					word.remove_tail (1)
				end
				if not list.is_first then
					line.append_character (' ')
				end
				if word.count > 1 and then eif.is_class_name (word)
					and then (not list.is_last implies word_list.i_th (list.cursor_index + 1) /~ Constraint_symbol)
				then
					line.append (Source_link_template #$ [word])
				else
					line.append (word)
				end
				if last_character.code.to_boolean then
					line.append_character (last_character)
				end
			end
			if line.has ('{') then
				-- for example: ${EL_DESCRIPTIVE_ENUMERATION}* [N -> {NUMERIC, HASHABLE}]
				line.edit ("{", "}", agent expand_constraint_list)
			end
		end

	reformat_output
		local
			tab_count, count: INTEGER; line: ZSTRING
			text_lines: EL_ITERABLE_SPLIT [STRING, ANY]
		do
			text_lines := File.plain_text_lines (output_path)
			if attached open (output_path, Write) as file_out then
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
						line.prune_all_trailing ('.')
						count := count + 1
						if count > 1 then
							expand_links (line, tab_count)
						end
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

	Constraint_symbol: ZSTRING
		once
			Result := "->"
		end

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

	Source_link_template: ZSTRING
		once
			Result := "${%S}"
		end

	Quote: ZSTRING
		local
			s: EL_ZSTRING_ROUTINES
		once
			Result := s.character_string ('"')
		end
end