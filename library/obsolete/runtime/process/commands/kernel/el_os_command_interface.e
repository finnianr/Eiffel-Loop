note
	description: "Summary description for {EL_OS_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-13 16:32:17 GMT (Monday 13th June 2016)"
	revision: "6"

deferred class
	EL_OS_COMMAND_INTERFACE

inherit
	EL_PLATFORM_IMPL
		redefine
			interface
		end

feature -- Access

	template: READABLE_STRING_GENERAL
			--
		deferred
		end

	error_redirection_suffix: STRING
		deferred
		end

	captured_system_command (command: ZSTRING): ZSTRING
		do
			Result := command.twin
			Result.append_string_general (file_redirection_operator)
			Result.append_string (output_file_path.to_string)
			if interface.redirect_errors then
				Result.append_string_general (Error_redirection_suffix)
			end
		end

feature -- Basic operations

	adjusted_output_lines: EL_LINEAR [ZSTRING]
		do
			Result := adjusted (new_output_lines)
		end

	escaped_path (a_path: EL_PATH): ZSTRING
		deferred
		end

feature {NONE} -- Implementation

	adjusted (lines: EL_LINEAR [ZSTRING]): EL_LINEAR [ZSTRING]
			-- Adjust command output lines for OS platform
		do
			Result := lines
		end

	new_output_lines: EL_LINEAR [ZSTRING]
		deferred
		end

	output_file_path: EL_FILE_PATH
		do
			Result := interface.temporary_file_path
		end

	interface: EL_OS_COMMAND [EL_OS_COMMAND_INTERFACE]

feature {NONE} -- Constants

	File_redirection_operator: STRING
		once
			Result := " >> "
		ensure
			padded_with_spaces: Result.item (1) = ' ' and Result.item (Result.count) = ' '
		end

end