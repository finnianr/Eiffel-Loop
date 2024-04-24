note
	description: "[
		Constants base on [http://www.nsftools.com/tips/RawFTP.htm list of raw ftp commands]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-24 16:01:21 GMT (Wednesday 24th April 2024)"
	revision: "15"

deferred class
	EL_FTP_IMPLEMENTATION

inherit
	FTP_PROTOCOL
		rename
			close as close_sockets,
			error as has_error,
			exception as exception_code,
			make as make_ftp,
			send as send_to_socket,
			login as ftp_login,
			last_reply as last_reply_utf_8,
			reply_code_ok as integer_32_reply_code_ok
		redefine
			close_sockets, send_password, send_transfer_command, send_username
		end

	EL_ITERATION_ROUTINES

	EL_FILE_OPEN_ROUTINES
		rename
			Open as File_open,
			Read as Read_from
		end

	EL_MODULE_EXCEPTION; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO; EL_MODULE_TUPLE; EL_MODULE_STRING_8

	EL_MODULE_USER_INPUT

	EL_STRING_8_CONSTANTS; EL_CHARACTER_8_CONSTANTS

	EL_SHARED_STRING_8_BUFFER_SCOPES

feature {NONE} -- Implementation

	authenticate
			-- Log in to server.
		require
			opened: is_open
		do
			is_logged_in := send_username and then send_password
		end

	close_sockets
		do
			Precursor
			initiating_listing := False
		end

	display_command_error (cmd: STRING; message: READABLE_STRING_GENERAL)
		local
			upper_command: STRING
		do
			if is_lio_enabled then
				upper_command := String_8.substring_to (cmd, ' ')
				upper_command.to_upper
				lio.put_labeled_string (upper_command + " error", message)
				lio.put_new_line
			end
		end

	display_error (message: READABLE_STRING_GENERAL)
		do
			if is_lio_enabled then
				lio.put_labeled_string (Error.label, message)
				lio.put_new_line
			end
		end

	display_reply_error
		do
			if is_lio_enabled then
				lio.put_labeled_string (Error.label + " server reply", last_reply)
				lio.put_new_line
			end
		end

	initiate_file_listing (dir_path: DIR_PATH)
		do
			across String_8_scope as scope loop
				push_address_path (unix_utf_8_path (scope, dir_path))
				set_passive_mode
				initiating_listing := True
				initiate_transfer
				pop_address_path
			end
		end

	pop_address_path
		do
			address.path.share (Stored_path)
		end

	push_address_path (new_path: STRING)
		do
			Stored_path.share (address.path)
			address.path.share (new_path)
		end

	receive_entry_list_count
		-- Parse `last_reply_utf_8' from acknowledgement to NLST data transfer
		-- Eg. "226 4 matches total%R%N"
		local
			split_list: EL_SPLIT_IMMUTABLE_UTF_8_LIST
		do
			receive (main_socket)
			create split_list.make_shared_adjusted (last_reply_utf_8, ' ', 0)
			if split_list.count = 0 then
				error_code := Transmission_error

			elseif attached split_list as list then
				from list.start until list.after loop
					inspect list.index
						when 1 then
							if split_list.natural_16_item /= Reply.closing_data_connection then
								error_code := Transmission_error
							end
						when 2 then
							set_last_entry_count (split_list.integer_item)
					else
					end
					list.forth
				end
			end
		end

	reply_code_ok (a_reply: STRING; codes: ARRAY [NATURAL_16]): BOOLEAN
		do
			if attached String_8.substring_to (a_reply, ' ') as part then
				Result := codes.has (part.to_natural_16)
			end
		end

	reset_file_listing
		do
			transfer_initiated := False; is_packet_pending := False
			initiating_listing := False
			data_socket := Void
		end

	send (cmd: IMMUTABLE_STRING_8; utf_8_path: detachable STRING; codes: ARRAY [NATURAL_16])
		require
			valid_path: cmd [cmd.count] = '%S' implies attached utf_8_path
		local
			utf_8_cmd: STRING; substitute_index: INTEGER
		do
			substitute_index := cmd.index_of ('%S', 1)
			across String_8_scope as scope loop
				if substitute_index > 0 then
					if attached utf_8_path as path then
						utf_8_cmd := scope.item
						utf_8_cmd.append_substring (cmd, 1, substitute_index - 1)
						utf_8_cmd.append (path)
					else
						utf_8_cmd := Empty_string_8
						error_code := Wrong_command
					end
				else
					utf_8_cmd := cmd
				end
				if error_code = Wrong_command then
					display_command_error (cmd, Error.missing_argument)
				else
					attempt (agent try_send (utf_8_cmd, codes, ?), 3)
				end
			end
		end

	send_absolute (cmd: IMMUTABLE_STRING_8; a_path: EL_PATH; codes: ARRAY [NATURAL_16])
		do
			if a_path.is_absolute then
				send_path (cmd, a_path, codes)

			elseif attached {FILE_PATH} a_path as file_path then
				send_path (cmd, current_directory + file_path, codes)

			elseif attached {DIR_PATH} a_path as dir_path then
				send_path (cmd, current_directory #+ dir_path, codes)
			end
		end

	send_path (cmd: IMMUTABLE_STRING_8; a_path: EL_PATH; codes: ARRAY [NATURAL_16])
		-- send command `cmd' with `path' argument and possible success `codes'
		do
			across String_8_scope as scope loop
				send (cmd, unix_utf_8_path (scope, a_path), codes)
			end
		end

	send_password: BOOLEAN
			-- Send password. Did it work?
		do
			if attached main_socket as l_socket then
				send_to_socket (l_socket, space.joined (Ftp_password_command, address.password))
				Result := reply_code_ok (last_reply_utf_8, <<
					Reply.command_not_implemented, Reply.user_logged_in -- Reply.service_ready
				>>)
				if not Result then
					error_code := Access_denied
				end
			else
				error_code := no_socket_to_connect
			end
		end

	send_transfer_command: BOOLEAN
		do
			if initiating_listing then
				if passive_mode then
					Result := send_passive_mode_command
				else
					Result := send_port_command
				end
				if Result then
					send (Command.name_list, address.path, << Reply.about_to_open_data_connection >>)
					if has_error then
						error_code := Permission_denied
					end
				end
			else
				Result := Precursor
			end
		end

	send_username: BOOLEAN
		-- Send username. Did it work?
		do
			if attached main_socket as l_socket then
				send_to_socket (l_socket, space.joined (Ftp_user_command, address.username))
				Result := reply_code_ok (last_reply_utf_8, <<
					Reply.user_logged_in, Reply.user_name_okay -- Reply.service_ready
				>>)
				if not Result then
					error_code := No_such_user
				end
			else
				error_code := no_socket_to_connect
			end
		end

	transfer_file (source_path, destination_path: FILE_PATH)
		do
			attempt (agent try_transfer_file (source_path, destination_path, ?), 3)
		end

	transfer_file_data (a_file_path: FILE_PATH)
			--
		local
			packet: PACKET; bytes_read: INTEGER
		do
			create packet.make (Default_packet_size)
			if attached open_raw (a_file_path, Read_from) as file_in then
				from until file_in.after loop
					file_in.read_to_managed_pointer (packet.data, 0, packet.count)
					bytes_read := file_in.bytes_read
					if bytes_read > 0 then
						if bytes_read /= packet.count then
							packet.data.resize (bytes_read)
						end
						data_socket.write (packet)
					end
				end
				data_socket.close
				data_socket := Void
				is_packet_pending := false
				file_in.close
			end
			receive (main_socket)
			if has_error then
				display_reply_error
			end
		end

	try_send (utf_8_command: STRING; codes: ARRAY [NATURAL_16]; done: BOOLEAN_REF)
		do
			reset_error
			send_to_socket (main_socket, utf_8_command)
			if last_succeeded then
				last_reply_utf_8.adjust
				last_reply_utf_8.to_lower
				if reply_code_ok (last_reply_utf_8, codes) then
					done.set_item (True)
				else
					error_code := Wrong_command
				end
			end
			if has_error then
				display_command_error (utf_8_command, error_text (error_code))
			end
		rescue
			close_sockets
			login
			retry
		end

	try_transfer_file (source_path, destination_path: FILE_PATH; done: BOOLEAN_REF)
		do
			across String_8_scope as scope loop
				push_address_path (unix_utf_8_path (scope, destination_path))
				set_passive_mode
				initiate_transfer
				pop_address_path
			end
			if transfer_initiated then
				transfer_file_data (source_path)
				transfer_initiated := False
			end
			if has_error then
				done.set_item (file_size (destination_path) = File.byte_count (source_path))
			else
				done.set_item (True)
			end
		ensure
			address_path_unchanged: old address.path ~ address.path
			unattached_data_socket: not attached data_socket
		end

	unix_utf_8_path (cursor: EL_BORROWED_STRING_8_CURSOR; a_path: EL_PATH): STRING
		do
			Result := cursor.item
			a_path.append_to_utf_8 (Result)
			if {PLATFORM}.is_windows then
				String_8.replace_character (Result, '\', '/')
			end
		end

feature {NONE} -- Deferred

	current_directory: DIR_PATH
		deferred
		end

	file_size (file_path: FILE_PATH): INTEGER
		deferred
		end

	last_reply: ZSTRING
		deferred
		end

	last_succeeded: BOOLEAN
		deferred
		end

	login
		deferred
		end

	reset
		deferred
		end

	set_last_entry_count (a_count: INTEGER)
		deferred
		end

feature {NONE} -- Internal attributes

	created_directory_set: EL_HASH_SET [DIR_PATH]

	initiating_listing: BOOLEAN
		-- `True' if initiating download of directory entry listing

	reply_parser: EL_FTP_REPLY_PARSER

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
		cannot_set_transfer_mode, invalid_login, label, missing_argument,
		not_regular_file, socket_error: ZSTRING
	]
		once
			create Result
			Tuple.fill (Result,
				"cannot set transfer mode, Invalid username or password, ERROR, missing argument,%
				%not a regular file, Socket error"
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