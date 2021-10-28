note
	description: "Windows implementation of [$source EL_FIND_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-28 8:54:25 GMT (Thursday 28th October 2021)"
	revision: "10"

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

	 adjusted_lines (lines: like new_output_lines): EL_ZSTRING_LIST
			-- Adjust results of Windows 'dir' to match Unix 'find' command with -mindepth and -maxdepth arguments
		local
			start_index, dir_path_occurrences, depth: INTEGER; line, line_substring, dir_path_string: ZSTRING
		do
			create Result.make (20)
			create line_substring.make_empty
			dir_path_occurrences := dir_path.step_count - 1
			if not dir_path.is_absolute then
				start_index := Directory.working.count + 2
			end
			if max_depth > 1 then
				from lines.start until lines.after loop
					line := lines.item
					if start_index.to_boolean then
--						Change absolute paths to be relative to current working directory for Linux compatibility
						line_substring.wipe_out
						line_substring.append_substring (line, start_index, line.count)
						line := line_substring
					end
					depth := line.occurrences ('\') - dir_path_occurrences
					if min_depth <= depth and then depth <= max_depth then
						if line = line_substring then
							Result.extend (line_substring.twin)
						else
							Result.extend (line)
						end
					end
					lines.forth
				end
			else
				dir_path_string := dir_path
				dir_path_string.append_character ('\')
				from lines.start until lines.after loop
					line := dir_path_string + lines.item
					line.prune_all_trailing ('\')
					Result.extend (line)
					lines.forth
				end
			end
		end

	get_escaped_path (field: EL_REFLECTED_PATH): ZSTRING
		do
			if name_pattern.is_empty then
				Result := Precursor (field)

			elseif attached {EL_DIR_PATH} field.value (Current) as l_path and then l_path = dir_path then
				Result := l_path.joined_dir_path (name_pattern).escaped
			else
				Result := Precursor (field)
			end
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