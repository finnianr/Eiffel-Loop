note
	description: "[
		Command to output a "descendants" note field for copy/pasting into Eiffel source code.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-29 12:37:59 GMT (Monday 29th October 2018)"
	revision: "3"

class
	CLASS_DESCENDANTS_COMMAND

inherit
	EL_REFLECTIVE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		end

	EL_COMMAND

	EL_MODULE_LOG

	EL_MODULE_COMMAND

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_ZSTRING_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_build_dir, a_output_dir: EL_DIR_PATH; a_class_name: STRING)
		local
			find_files: EL_FIND_FILES_COMMAND_I
		do
			build_dir := a_build_dir; output_dir := a_output_dir; class_name := a_class_name
			create ecf_path
			output_path := output_dir + (a_class_name + ".txt")
			output_path.base.prepend_string_general ("Descendants-")

			if output_path.exists then
				File_system.remove_file (output_path)
			end
			find_files := Command.new_find_files (Directory.current_working, "*.ecf")
			find_files.set_max_depth (1)
			find_files.execute
			if not find_files.path_list.is_empty then
				ecf_path := find_files.path_list.first
			end
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			if ecf_path.is_empty then
				lio.put_path_field ("ERROR: no", ecf_path)
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

feature {NONE} -- Implementation

	output_lines
		local
			file_out: EL_PLAIN_TEXT_FILE; source: EL_FILE_LINE_SOURCE
			lines: EL_ZSTRING_LIST; tab_count, count: INTEGER
			line: ZSTRING
		do
			create source.make_latin (1, output_path)
			lines := source.list
			source.close

			if not output_dir.exists then
				File_system.make_directory (output_dir)
			end
			create file_out.make_open_write (output_path)
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
					line.replace_delimited_substring (Generic_param_start, Generic_param_end, Empty_string, True, 1)
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

feature {NONE} -- Internal attributes

	build_dir: EL_DIR_PATH

	class_name: STRING

	ecf_path: EL_FILE_PATH

	output_dir: EL_DIR_PATH

	output_path: EL_FILE_PATH

feature {NONE} -- Constants

	Generic_param_start: ZSTRING
		once
			Result := " ["
		end

	Generic_param_end: ZSTRING
		once
			Result := "]"
		end

	Descendants_command: EL_OS_COMMAND
		once
			create Result.make_with_name (
				"descendants",
				"ec -descendants $class_name -project_path $build_dir -config $ecf_path -file $output_path"
			)
		end

end
