note
	description: "FTP command constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-29 14:12:01 GMT (Monday 29th April 2024)"
	revision: "2"

deferred class
	EL_FTP_COMMAND_CONSTANTS

inherit
	EL_ANY_SHARED

	TRANSFER_COMMAND_CONSTANTS
		rename
			Http_end_of_header_line as Carriage_return_new_line
		undefine
			is_equal
		end

	EL_MODULE_EXCEPTION; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO; EL_MODULE_TUPLE; EL_MODULE_STRING_8; EL_MODULE_USER_INPUT

	EL_STRING_8_CONSTANTS; EL_CHARACTER_8_CONSTANTS

	EL_SHARED_STRING_8_BUFFER_SCOPES

feature {NONE} -- Numeric constants

	Default_buffer_size: INTEGER
			-- Default size of read buffer
		once
			Result := 16384
		end

	Default_packet_size: INTEGER
		once
			Result := 2048
		end

	Max_login_attempts: INTEGER
		once
			Result := 2
		end

feature {NONE} -- Constants

	Is_binary_mode_command: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make (Ftp_text_mode_command, Ftp_binary_mode_command)
		end

	Command: TUPLE [
		change_working_directory, delete_file, make_directory, name_list,
		print_working_directory, quit, remove_directory, size: IMMUTABLE_STRING_8
	]
		once
			create Result
			Tuple.fill_immutable (Result, "CWD %S, DELE %S, MKD %S, NLST %S, PWD, QUIT, RMD %S, SIZE %S")
		end

	Error: TUPLE [
		cannot_enter_passive_mode, cannot_set_transfer_mode, invalid_login,
		label, missing_argument, socket_error: ZSTRING
	]
		once
			create Result
			Tuple.fill (Result,
				"cannot_enter_passive_mode, cannot set transfer mode, Invalid username or password,%
				%ERROR, missing argument, Socket error"
			)
		end

	File_not_found_responses: EL_STRING_8_LIST
		-- variation of reponses to `Command.size' for a directory
		-- Eg. 550 file not found (/htdocs/w_code/c1).
		once
			Result := "not a regular file, file not found"
		end

	Reply: EL_FTP_SERVER_REPLY_ENUM
		once
			create Result.make
		end

end