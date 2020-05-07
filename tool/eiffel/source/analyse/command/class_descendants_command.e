note
	description: "[
		Command to output a "descendants" note field for copy/pasting into Eiffel source code.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-07 12:34:35 GMT (Thursday 7th May 2020)"
	revision: "8"

class
	CLASS_DESCENDANTS_COMMAND

inherit
	EL_REFLECTIVE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_FILE_OPEN_ROUTINES

	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_COMMAND

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_ZSTRING_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_build_dir, a_output_dir: EL_DIR_PATH; a_class_name: STRING; a_target_name: ZSTRING)
		do
			make_machine

			build_dir := a_build_dir; output_dir := a_output_dir; class_name := a_class_name
			target_name := a_target_name
			create ecf_path
			output_path := output_dir + (a_class_name + ".txt")
			output_path.base.prepend_string_general ("Descendants-")

			if output_path.exists then
				File_system.remove_file (output_path)
			end
			set_ecf_path_from_target
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			if ecf_path.is_empty then
				lio.put_string_field ("ERROR: Cannot find ECF file with target", target_name)
				lio.put_new_line
			else
				lio.put_path_field ("Writing", output_path)
				lio.put_new_line
				Descendants_command.put_object (Current)
				Descendants_command.execute
				output_lines
				lio.put_line ("DONE")
			end
			log.exit
		end

feature {NONE} -- Line states

	find_target_name (line: ZSTRING; a_ecf_path: EL_FILE_PATH)
		local
			l_target_name: ZSTRING
		do
			if line.begins_with (Element_target_name) then
				l_target_name := line.substring_between (character_string ('"'), character_string ('"'), 1).as_lower
				if l_target_name ~ target_name then
					ecf_path := a_ecf_path
				end
				state := final
			end
		end

feature {NONE} -- Implementation

	output_lines
		local
			lines: EL_ZSTRING_LIST; tab_count, count: INTEGER
			line, text: ZSTRING
		do
			text := File_system.plain_text (output_path)
			text.edit (" [", "]%N", agent remove_parameter_brackets)
			create lines.make_with_lines (text)

			if not output_dir.exists then
				File_system.make_directory (output_dir)
			end
			if attached open (output_path, Write) as file_out then
				file_out.put_lines (<<
					"note",
					"%Tdescendants: %"See end of class%"",
					"%Tdescendants: %"["
				>>)
				file_out.put_new_line
				from lines.start until lines.after loop
					line := lines.item
					tab_count := line.leading_occurrences ('%T')
					if line.count > tab_count then
						count := count + 1
						line.prune_all_trailing ('.')
						if count > 1 then
							line.insert_string_general ("[$source ", tab_count + 1)
							if line [line.count] = '*' then
								line.insert_character (']', line.count)
							else
								line.append_character (']')
							end
						end
						file_out.put_string_8 ("%T%T")
						file_out.put_string (line)
						file_out.put_new_line
					end
					lines.forth
				end
				file_out.put_string_8 ("%T]%"")
				file_out.close
			end
		end

	remove_parameter_brackets (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			substring.wipe_out
			substring.append_character ('%N')
		end

	set_ecf_path_from_target
		local
			find_files: EL_FIND_FILES_COMMAND_I
		do
			find_files := Command.new_find_files (Directory.current_working, "*.ecf")
			find_files.set_max_depth (1)
			find_files.execute

			across find_files.path_list as path until not ecf_path.is_empty loop
				do_with_lines (agent find_target_name (?, path.item), open_lines (path.item, Latin_1))
			end
		end

feature {NONE} -- Internal attributes

	build_dir: EL_DIR_PATH

	class_name: STRING

	ecf_path: EL_FILE_PATH

	output_dir: EL_DIR_PATH

	output_path: EL_FILE_PATH

	target_name: ZSTRING

feature {NONE} -- Constants

	Element_target_name: ZSTRING
		once
			Result := "<target name"
		end

	Descendants_command: EL_OS_COMMAND
		once
			create Result.make_with_name (
				"descendants",
				"ec -descendants $class_name -project_path $build_dir -config $ecf_path -file $output_path"
			)
		end

end
