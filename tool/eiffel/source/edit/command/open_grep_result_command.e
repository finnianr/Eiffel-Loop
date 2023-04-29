note
	description: "Count classes, code words and combined source file size for Eiffel source trees"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-29 8:57:18 GMT (Saturday 29th April 2023)"
	revision: "21"

class
	OPEN_GREP_RESULT_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_FILE_OPEN_ROUTINES

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	GREP_RESULT_CONSTANTS

	EL_MODULE_LIO

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_grep_result_path: FILE_PATH; a_cursor_line: INTEGER)
		do
			grep_result_path := a_grep_result_path; cursor_line := a_cursor_line
			make_machine
			create last_cluster_path
			create target_source_path
			create last_base_name.make_empty
		end

feature -- Access

	Description: STRING = "[
		Open grep result at line number with gedit
	]"

feature -- Basic operations

	execute
		do
			if attached open_lines (grep_result_path, Mixed_utf_8_latin_1) as lines then
				do_once_with_file_lines (agent find_cursor_line, lines)
				if last_base_name.count > 0 and target_line_number > 0 then
					target_source_path := last_cluster_path + last_base_name
					target_source_path.add_extension ("e")
					if target_source_path.exists and then attached Gedit_command as gedit then
						gedit.set_line_number (target_line_number)
						gedit.set_source_path (target_source_path)
						gedit.execute
					else
						lio.put_path_field ("Target not found", target_source_path)
						lio.put_new_line
					end
				end
			end
		end

feature {NONE} -- Implementation

	find_cursor_line (line: ZSTRING)
		local
			index_colon, index_comment: INTEGER; line_string: ZSTRING
		do
			if line_number = cursor_line then
				index_colon := line.index_of (':', 1)
				if index_colon > 0 then
					line_string := line.substring (1, index_colon - 1)
					line_string.left_adjust
					target_line_number := line_string.to_integer
				end
				state := final

			elseif line.starts_with (Comment.directory) then
				last_cluster_path.set_path (line.substring_end (Comment.directory.count + 1))

			elseif line.starts_with (Class_keyword) then
				index_comment := line.substring_index (Comment.matching_lines, 1)
				if index_comment > 0 then
					last_base_name := line.substring (Class_keyword.count + 2, index_comment - 2)
					last_base_name.to_lower
				end
			end
		end

feature {NONE} -- Internal attributes

	cursor_line: INTEGER

	grep_result_path: FILE_PATH

	last_base_name: ZSTRING

	last_cluster_path: DIR_PATH

	target_line_number: INTEGER

	target_source_path: FILE_PATH

feature {NONE} -- Constants

	Gedit_command: GEDIT_COMMAND
		once
			create Result.make
		end

end