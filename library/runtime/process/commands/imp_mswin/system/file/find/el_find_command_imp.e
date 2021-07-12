note
	description: "Windows implementation of [$source EL_FIND_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-12 12:09:19 GMT (Monday 12th July 2021)"
	revision: "7"

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
			make_default, do_command, new_command_parts, reset
		end

	EL_MODULE_DIRECTORY

feature {NONE} -- Implementation

	 adjusted_lines (lines: like new_output_lines): EL_ZSTRING_LIST
			-- Adjust results of Windows 'dir' to match Unix 'find' command with -mindepth and -maxdepth arguments
		local
			line_position, dir_path_occurrences, depth: INTEGER; line: ZSTRING
		do
			create Result.make (20)
			dir_path_occurrences := dir_path.step_count - 1
			if not dir_path.is_absolute then
				line_position := Directory.working.to_string.count + 2
			end
			if max_depth > 1 then
				from lines.start until lines.after loop
					if line_position > 0 then
--						Change absolute paths to be relative to current working directory for Linux compatibility
						line := lines.item.substring (line_position, lines.item.count)
					else
						line := lines.item
					end
					depth := line.occurrences ('\') - dir_path_occurrences
					if min_depth <= depth and then depth <= max_depth then
						Result.extend (line)
					end
					lines.forth
				end
			else
				from lines.start until lines.after loop
					Result.extend (dir_path + lines.item)
					lines.forth
				end
			end
		end

	get_escaped_path: ZSTRING
		do
			if name_pattern.is_empty then
				Result := dir_path.escaped
			else
				Result := dir_path.joined_dir_path (name_pattern).escaped
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