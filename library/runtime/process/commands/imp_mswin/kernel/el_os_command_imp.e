note
	description: "Windows implementation of [$source EL_OS_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-02 19:36:24 GMT (Tuesday 2nd January 2024)"
	revision: "20"

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

feature {NONE} -- Implementation

	new_output_lines (file_path: FILE_PATH): EL_PLAIN_TEXT_LINE_SOURCE
		do
			create Result.make_encoded (Encodings.Console, file_path)
		end

	run_as_administrator (command_string: ZSTRING)
		local
			cmd: EL_WINDOWS_ADMIN_SHELL_COMMAND
		do
			create cmd.make
			cmd.set_command_and_parameters (command_string)
			cmd.execute
			has_error := not cmd.is_successful
		end

feature -- Constants

	Command_prefix: STRING_32
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