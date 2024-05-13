note
	description: "[
		Constants base on [http://www.nsftools.com/tips/RawFTP.htm list of raw ftp commands]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-13 9:24:35 GMT (Monday 13th May 2024)"
	revision: "20"

deferred class
	EL_FTP_IMPLEMENTATION

inherit
	EL_FTP_NETWORK_RESOURCE
		rename
			make as make_ftp,
			last_reply as last_reply_utf_8
		end

	EL_ITERATION_ROUTINES

	EL_FILE_OPEN_ROUTINES
		rename
			Open as File_open,
			Read as Read_from
		end

feature -- Access

	last_reply: ZSTRING
		do
			create Result.make_from_utf_8 (last_reply_utf_8)
			Result.right_adjust
		end

feature -- Measurement

	file_size (file_path: FILE_PATH): INTEGER
		do
			send_path (Command.size, file_path, << Reply.file_status >>)
			if last_succeeded then
				Result := String_8.substring_to_reversed (last_reply_utf_8, ' ').to_integer
			end
		end

	last_entry_count: INTEGER
		-- directory entry count set by `read_entry_count' or

feature -- Status query

	last_succeeded: BOOLEAN
		do
			Result := error_code = 0
		end

feature {NONE} -- Sending commands

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

	send_command (parts: ARRAY [STRING]; valid_replies: ARRAY [NATURAL_16] error_type_code: INTEGER): BOOLEAN
		do
			if attached main_socket as socket then
				if attached socket.command_reply (parts) as l_reply then
					last_reply_utf_8 := l_reply
					Result := valid_replies.has (reply_code (l_reply))
					if not Result then
						error_code := error_type_code
					end
				else
					error_code := Transmission_error
				end
			else
				error_code := no_socket_to_connect
			end
		end

	send_passive_mode_command: BOOLEAN
		-- Send passive mode command. Did it work?
		do
			Result := send_command (
				<< Ftp_passive_mode_command >>, Reply.valid_enter_passive_mode, Wrong_command
			)
		end

	send_password: BOOLEAN
			-- Send password. Did it work?
		do
			Result := send_command (
				<< Ftp_password_command, address.password >>, Reply.valid_password, Access_denied
			)
		end

	send_path (cmd: IMMUTABLE_STRING_8; a_path: EL_PATH; codes: ARRAY [NATURAL_16])
		-- send command `cmd' with `path' argument and possible success `codes'
		do
			across String_8_scope as scope loop
				send (cmd, unix_utf_8_path (scope, a_path), codes)
			end
		end

	send_port_command: BOOLEAN
			-- Send PORT command. Did it work?
		require
			data_socket_exists: attached data_socket
		do
			if attached data_socket as socket then
				Result := send_command (
					<< Ftp_port_command, new_localhost_port_string (socket.port) >>, Reply.valid_response, Wrong_command
				)
			end
		end

	send_transfer_command: BOOLEAN
		local
			cmd: STRING
		do
			if initiating_listing and data_socket = Void then
				if passive_mode then
					Result := enter_passive_mode_for_data
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
				if attached main_socket as socket then
					if passive_mode then
						Result := enter_passive_mode_for_data
					else
						Result := send_port_command
					end

					if Result then
						if Read_mode then
							cmd := Ftp_retrieve_command
						else
							check write_mode: write_mode end
							cmd := Ftp_store_command
						end
						Result := send_command (
							<< cmd, address.path >>, << Reply.about_to_open_data_connection >>, Permission_denied
						)
						if Result and then Read_mode then
							set_resource_size (last_reply_utf_8)
						end
					end
				else
					error_code := no_socket_to_connect
				end
			end
		end

	send_transfer_mode_command: BOOLEAN
		-- Send transfer mode command. Did it work?
		do
			Result := send_command (
				<< Is_binary_mode_command [is_binary_mode] >>, Reply.valid_response, Wrong_command
			)
		end

	send_username: BOOLEAN
		-- Send username. Did it work?
		do
			Result := send_command (
				<< Ftp_user_command, address.username >>, Reply.valid_username, No_such_user
			)
		end

	try_send (utf_8_command: STRING; valid_replies: ARRAY [NATURAL_16]; done: BOOLEAN_REF)
		do
			reset_error
			if send_command (<< utf_8_command >>, valid_replies, Wrong_command) then
				done.set_item (True)
			end
			if has_error then
				display_command_error (utf_8_command, error_text (error_code))
			end
		rescue
			close_sockets
			login
			retry
		end

feature {NONE} -- Implementation

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

	enter_passive_mode_for_data: BOOLEAN
		do
			Result := send_passive_mode_command
			if Result and then attached new_data_socket as socket then
				socket.connect
				data_socket := socket
			else
				Result := False
			end
		end

	initiate_file_listing (dir_path: DIR_PATH)
		do
			across String_8_scope as scope loop
				push_address_path (unix_utf_8_path (scope, dir_path))
				set_passive_mode
				initiating_listing := True
				last_entry_count := 0
				initiate_transfer
				pop_address_path
			end
		end

	initiate_transfer
		local
			socket: like accepted_socket
		do
			if is_proxy_used then
				check attached proxy_connection as l_proxy then
					l_proxy.initiate_transfer
				end
			else
				if not passive_mode then
					create socket.make_server (Current)
					data_socket := socket
					socket.set_timeout (timeout)
					socket.listen (1)
				end
				if send_transfer_command then
					debug Io.error.put_string ("Accepting socket...%N") end
					if passive_mode then
						accepted_socket := data_socket

					elseif attached socket then
						socket.accept
						socket := socket.accepted
						check l_socket_attached: attached socket end
						accepted_socket := socket
					end
					if attached accepted_socket then
						debug Io.error.put_string ("Socket accepted%N") end
						transfer_initiated := True
						is_packet_pending := True
					else
						error_code := Connection_refused
					end
				end
			end
		ensure then
			connection_established: attached data_socket as l_data_socket and then
				(l_data_socket.is_open_read or l_data_socket.is_open_write)
		rescue
			error_code := Connection_refused
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

	reset_file_listing
		do
			transfer_initiated := False; is_packet_pending := False
			initiating_listing := False
			data_socket := Void
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
			if attached main_socket as socket
				and then attached open_raw (a_file_path, Read_from) as file_in
			then
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
				if attached socket.received_reply as str then
					last_reply_utf_8 := str
				end
			end
			if has_error then
				display_reply_error
			end
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

	login
		deferred
		end

feature {NONE} -- Internal attributes

	created_directory_set: EL_HASH_SET [DIR_PATH]

	reply_parser: EL_FTP_REPLY_PARSER

feature {NONE} -- Buffers

	Stored_path: STRING
		once
			create Result.make_empty
		end

end