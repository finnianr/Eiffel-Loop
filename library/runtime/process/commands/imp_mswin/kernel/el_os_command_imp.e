note
	description: "Windows implementation of ${EL_OS_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-08 12:02:36 GMT (Thursday 8th May 2025)"
	revision: "27"

deferred class
	EL_OS_COMMAND_IMP

inherit
	EL_OS_COMMAND_I
		undefine
			getter_function_table, make_default, new_transient_fields
		end

	EL_WINDOWS_IMPLEMENTATION

	EL_SHARED_ENCODINGS

	EL_FILE_OPEN_ROUTINES

	EL_CHARACTER_8_CONSTANTS

feature {NONE} -- Implementation

	new_output_lines (file_path: FILE_PATH): EL_PLAIN_TEXT_LINE_SOURCE
		do
			create Result.make_encoded (Encodings.Console, file_path)
		end

	run_as_administrator (command_parts: EL_ZSTRING_LIST)
		local
			cmd: EL_WINDOWS_SHELL_COMMAND; extended_parts: EL_ZSTRING_LIST
		do
			create cmd.make
		-- Create extended form of `command_parts': "cmd /U /C cd /D $CWD && $COMMAND"
			create extended_parts.make (command_parts.count + 3)
			extended_parts.extend (command_parts [1])
			extended_parts.append (<<
				Change_dir_command, effective_working_directory.to_string, char ('&').as_zstring (2)
			>>)
			across command_parts as part loop
				if part.cursor_index > 1 then
					extended_parts.extend (part.item)
				end
			end
			cmd.set_command_and_parameters (extended_parts.as_word_string)
			cmd.enable_hide
			cmd.enable_administrator
			cmd.execute
			has_error := not cmd.is_successful
		end

feature -- Constants

	Change_dir_command: ZSTRING
		once
			Result := "cd /D"
		end

	Command_prefix: ZSTRING
		-- Force output of command to be UTF-16
		once
			Result := "cmd /U /C"
		end

	Error_redirection_suffix: STRING = ""

	Null_redirection: ZSTRING
		once
			Result := "> nul 2>&1"
		end

end