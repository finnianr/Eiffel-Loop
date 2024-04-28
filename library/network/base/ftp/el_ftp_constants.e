note
	description: "FTP constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-27 18:42:16 GMT (Saturday 27th April 2024)"
	revision: "1"

deferred class
	EL_FTP_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_EXCEPTION; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO; EL_MODULE_TUPLE; EL_MODULE_STRING_8; EL_MODULE_USER_INPUT

	EL_STRING_8_CONSTANTS; EL_CHARACTER_8_CONSTANTS

	EL_SHARED_STRING_8_BUFFER_SCOPES

feature {NONE} -- Numeric constants

	Default_packet_size: INTEGER
		once
			Result := 2048
		end

	Max_login_attempts: INTEGER
		once
			Result := 2
		end

feature {NONE} -- Constants

	Carriage_return_new_line: STRING = "%R%N"

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
		label, missing_argument, not_regular_file, socket_error: ZSTRING
	]
		once
			create Result
			Tuple.fill (Result,
				"cannot_enter_passive_mode, cannot set transfer mode, Invalid username or password,%
				%ERROR, missing argument, not a regular file, Socket error"
			)
		end

	Reply: EL_FTP_SERVER_REPLY_ENUM
		once
			create Result.make
		end

	Stored_path: STRING
		once
			create Result.make_empty
		end

end