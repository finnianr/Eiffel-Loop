note
	description: "OS command with captured output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-10 9:54:57 GMT (Friday 10th November 2017)"
	revision: "4"

deferred class
	EL_CAPTURED_OS_COMMAND_I

inherit
	EL_OS_COMMAND_I
		redefine
			do_command, new_command_string
		end

feature {NONE} -- Factory

	new_command_string (a_system_command: like system_command): STRING_32
		local
			l_output_file_path: STRING_32
		do
			Result := Precursor (a_system_command)
			l_output_file_path := temporary_output_file_path
			Result.grow (Result.count + Output_redirection_operator.count + l_output_file_path.count)
			Result.append (Output_redirection_operator); Result.append (l_output_file_path)
		end

feature {NONE} -- Implementation

	adjusted_lines (lines: like new_output_lines): EL_LINEAR [ZSTRING]
			-- command output lines adjusted for OS platform
		do
			Result := lines
		end

	do_command (a_system_command: ZSTRING)
			--
		do
			Precursor (a_system_command)
			if not has_error then
				do_with_lines (adjusted_lines (new_output_lines (output_file_path)))
			end
			File_system.remove_file (temporary_output_file_path)
		end

	do_with_lines (lines: like adjusted_lines)
			--
		deferred
		end

	output_file_path: EL_FILE_PATH
		do
			Result := temporary_output_file_path
		end

	temporary_output_file_path: EL_FILE_PATH
		do
			Result := Temporary_output_path_by_type.item (Current)
		end

feature {NONE} -- Constants

	Output_redirection_operator: STRING_32
		once
			Result := " > "
		end

	Temporary_output_path_by_type: EL_FUNCTION_RESULT_TABLE [EL_CAPTURED_OS_COMMAND_I, EL_FILE_PATH]
		once
			create Result.make (17, agent {EL_CAPTURED_OS_COMMAND_I}.new_temporary_file_path ("txt"))
		end
end
