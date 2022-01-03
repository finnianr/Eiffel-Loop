note
	description: "Windows implementation of [$source EL_FIND_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:52 GMT (Monday 3rd January 2022)"
	revision: "12"

deferred class
	EL_FIND_COMMAND_IMP

inherit
	EL_FIND_COMMAND_I
		export
			{NONE} all
		redefine
			adjusted_lines, get_escaped_path
		end

	EL_OS_COMMAND_IMP
		export
			{NONE} all
		undefine
			do_command, get_escaped_path, new_command_parts, reset
		end

	EL_MODULE_DIRECTORY

feature {NONE} -- Implementation

	get_escaped_path (field: EL_REFLECTED_PATH): ZSTRING
		do
			if name_pattern.is_empty then
				Result := Precursor (field)

			elseif attached {DIR_PATH} field.value (Current) as l_path and then l_path = dir_path then
				Result := l_path.joined_dir_path (name_pattern).escaped
			else
				Result := Precursor (field)
			end
		end

	adjusted_lines (output_lines: like new_output_lines): like new_output_lines
		local
			start_index, dir_path_occurrences, depth: INTEGER
			line, line_substring, dir_path_string: ZSTRING
		do
			prepend_directory (output_lines)

			create Result.make (output_lines.count)
			dir_path_occurrences := dir_path.step_count - 1
			if not dir_path.is_absolute then
				start_index := Directory.working.count + 2
			end
			if max_depth > 1 then
				across output_lines as list loop
					line := list.item
					if start_index.to_boolean then
--						Change absolute paths to be relative to current working directory for Linux compatibility
						if start_index > line.count then
							line.wipe_out
						else
							line.keep_tail (line.count - start_index + 1)
						end
						line.trim
					end
					depth := line.occurrences ('\') - dir_path_occurrences
					if min_depth <= depth and then depth <= max_depth then
						Result.extend (line)
					end
				end
			else
				dir_path_string := dir_path
				dir_path_string.append_character ('\')
				across output_lines as list loop
					line := dir_path_string + list.item
					line.prune_all_trailing ('\')
					Result.extend (line)
				end
			end
		end

	prepend_directory (output_lines: EL_ZSTRING_LIST)
		do
		end

feature {NONE} -- Constants

	Template: STRING = "[
		dir /B
		
		#if $max_depth > 1 then
			/S
		#end
		
		/A$type $dir_path
	]"

end