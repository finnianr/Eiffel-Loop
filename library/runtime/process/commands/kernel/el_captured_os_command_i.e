note
	description: "OS command with captured output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-26 17:23:39 GMT (Wednesday 26th March 2025)"
	revision: "17"

deferred class
	EL_CAPTURED_OS_COMMAND_I

inherit
	EL_OS_COMMAND_I
		redefine
			do_command, is_captured, new_command_parts
		end

feature -- Status query

	is_captured: BOOLEAN = True

feature {NONE} -- Factory

	new_command_parts (a_system_command: like system_command): ARRAY [ZSTRING]
		do
			Result := <<
				command_prefix, a_system_command, Error_redirection_operator, temporary_error_file_path,
				Output_redirection_operator, temporary_output_file_path
			>>
		end

feature {NONE} -- Implementation

	do_command (a_system_command: ZSTRING)
			--
		local
			l_output_path: like output_file_path
		do
			l_output_path := output_file_path
			File_system_mutex.lock
				File_system.make_directory (output_file_path.parent)
			File_system_mutex.unlock
			Precursor (a_system_command)
			if not has_error then
				if l_output_path.exists and then attached new_output_lines (l_output_path) as lines then
					do_with_lines (lines)
					-- Failure to close file will result on an error on deletion with Windows
					lines.close
				end
			end
			File_system_mutex.lock
				if l_output_path.exists then
					File_system.remove_file (l_output_path)
				end
			File_system_mutex.unlock
		end

	do_with_lines (line_source: like new_output_lines)
			--
		deferred
		end

	i_th_line (line_source: like new_output_lines; i: INTEGER): detachable ZSTRING
		local
			break: BOOLEAN
		do
			across line_source as line until break loop
				if line.cursor_index = i then
					Result := line.item_copy
					break := True
				end
			end
		end

	output_file_path: FILE_PATH
		do
			Result := temporary_output_file_path
		end

	temporary_output_file_path: FILE_PATH
		do
			Result := Temporary_output_path_by_type.item (Current)
		end

feature {NONE} -- Constants

	Output_redirection_operator: ZSTRING
		once
			Result := ">"
		end

	Temporary_output_path_by_type: EL_FUNCTION_RESULT_TABLE [EL_CAPTURED_OS_COMMAND_I, FILE_PATH]
		once
			create Result.make (17, agent {EL_CAPTURED_OS_COMMAND_I}.new_temporary_file_path ("txt"))
		end
end