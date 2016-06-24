note
	description: "OS command with captured output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-19 15:22:29 GMT (Sunday 19th June 2016)"
	revision: "5"

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
			if not is_asynchronous then
				l_output_file_path := temporary_output_file_path.unicode
				Result.grow (Result.count + Output_redirection_operator.count + l_output_file_path.count)
				Result.append (Output_redirection_operator); Result.append (l_output_file_path)
			end
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
			if not (is_asynchronous or has_error) then
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
			Result := Temporary_output_path_by_type.item ({like Current}, agent new_temporary_file_path ("txt"))
		end

feature {NONE} -- Constants

	Output_redirection_operator: STRING_32
		once
			Result := " > "
		end

	Temporary_output_path_by_type: EL_TYPE_TABLE [EL_FILE_PATH]
		once
			create Result.make_equal (17)
		end
end
