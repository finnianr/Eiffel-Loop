note
	description: "Ftp protocol"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 16:27:20 GMT (Saturday 6th March 2021)"
	revision: "21"

class
	EL_FTP_PROTOCOL

inherit
	FTP_PROTOCOL
		rename
			exception as exception_code,
			send as send_to_socket,
			make as make_protocol,
			login as ftp_login,
			last_reply as last_reply_utf_8
		export
			{EL_FTP_AUTHENTICATOR} send_username, send_password
		redefine
			close, open
		end

	EL_FILE_OPEN_ROUTINES
		rename
			Open as File_open,
			Read as Read_from
		end

	EL_MODULE_EXCEPTION

	EL_MODULE_FTP_COMMAND

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_SHARED_PROGRESS_LISTENER

create
	make_write, make_default

feature {EL_FTP_SYNC} -- Initialization

	make (a_address: like address; a_mode: INTEGER)
			-- Create protocol.
		do
			make_default
			make_protocol (a_address)
			mode := a_mode
		end

	make_default
		do
			create authenticator.make (Current)
			create current_directory
			set_binary_mode
			create reply_parser.make
			make_protocol (Default_url)
		end

	make_read (a_address: like address)
		do
			make (a_address, Read_mode_id)
		end

	make_write (a_address: like address)
		do
			make (a_address, Write_mode_id)
		end

feature -- Access

	current_directory: EL_DIR_PATH

	home_directory: EL_DIR_PATH

	last_reply: ZSTRING
		do
			create Result.make_from_utf_8 (last_reply_utf_8)
			Result.right_adjust
		end

feature -- Element change

	set_current_directory (a_current_directory: EL_DIR_PATH)
		do
			send (Ftp_command.change_directory (absolute_dir (a_current_directory)), << 200, 250 >>)
			if last_succeeded then
				if a_current_directory.is_absolute then
					current_directory := a_current_directory
				else
					current_directory := current_directory.joined_dir_path (a_current_directory)
				end
			end
		ensure
			changed: get_current_directory ~ current_directory
		end

	set_home_directory (a_home_directory: like home_directory)
			-- Set `home_directory' to `a_home_directory'.
		require
			is_absolute: a_home_directory.is_absolute
		do
			home_directory := a_home_directory
		end

	set_login_prompts (user_name_and_password: READABLE_STRING_GENERAL)
		require
			comma_separated: user_name_and_password.has (',')
		do
			authenticator.set_input_prompts (user_name_and_password)
		end

feature -- Remote operations

	change_home_dir
		do
			set_current_directory (home_directory)
		end

	delete_file (file_path: EL_FILE_PATH)
		do
			if file_exists (file_path) then
				send (Ftp_command.delete_file (file_path), << 250 >>)
				progress_listener.notify_tick
			else
				last_succeeded := True
			end
		ensure
			succeeded: last_succeeded
		end

	make_directory (dir_path: EL_DIR_PATH)
			-- Create directory relative to current directory
		require
			dir_path_is_relative: not dir_path.is_absolute
		local
			parent_dir: EL_DIR_PATH; parent_exists: BOOLEAN
		do
			if not directory_exists (dir_path) then
				parent_dir := dir_path.parent
				parent_exists := directory_exists (parent_dir)
				if not parent_exists then
					make_directory (parent_dir)
					parent_exists := last_succeeded
				end
				if parent_exists then
					send (Ftp_command.make_directory (dir_path), << 257 >>)
				end
			end
		ensure
			exists: directory_exists (dir_path)
		end

	remove_directory (dir_path: EL_DIR_PATH)
		do
			if directory_exists (dir_path) then
				send (Ftp_command.remove_directory (absolute_dir (dir_path)), << 250 >>)
			else
				last_succeeded := True
			end
		end

feature -- Basic operations

	upload (item: EL_FTP_UPLOAD_ITEM)
			-- upload file to destination directory relative to home directory
		require
			binary_mode_set: is_binary_mode
			file_to_upload_exists: item.source_path.exists
		local
			is_retry: BOOLEAN
		do
			if is_retry then
				lio.put_new_line
				login; change_home_dir
			end
			make_directory (item.destination_dir)

			address.path.share (item.destination_file_path.to_utf_8)
			set_passive_mode
			initiate_transfer
			if transfer_initiated then
				transfer_file_data (item.source_path)
				transfer_initiated := false
				if not is_retry then
					progress_listener.notify_tick
				end
			else
				Exception.raise_developer ("Failed to transfer: %S", [item.source_path.base])
			end
		ensure
			data_socket_close: data_socket.is_closed
		rescue
			lio.put_new_line
			lio.put_labeled_string ("Socket error", data_socket.error)
			lio.put_new_line
			lio.put_labeled_string ("Description", Exception.last_exception.description)
			lio.put_new_line
			data_socket.close
			reset_error
			close
			is_retry := True
			retry
		end

feature -- Status report

	directory_exists (dir_path: EL_DIR_PATH): BOOLEAN
			-- Does remote directory exist
		do
			if dir_path.is_empty then
				Result := True
			else
				send (Ftp_command.size (absolute_dir (dir_path)), << 550 >>)
				Result := last_succeeded and then last_reply_utf_8.has_substring (Not_regular_file)
			end
		end

	file_exists (file_path: EL_FILE_PATH): BOOLEAN
			-- Does remote directory exist
		do
			if file_path.is_empty then
				Result := True
			else
				send (Ftp_command.size (absolute_file_path (file_path)), << 213 >>)
				Result := last_succeeded
			end
		end

	has_error: BOOLEAN
		do
			Result := not last_succeeded
		end

	is_default_state: BOOLEAN
		do
			Result := address = Default_url
		end

	last_succeeded: BOOLEAN

feature -- Status change

	close
			--
		do
			if is_logged_in then
				quit
			end
			Precursor
		end

	login
		local
			attempts: INTEGER
		do
			if not is_open then
				open
			end
			from attempts := 1 until is_logged_in or attempts > Max_login_attempts loop
				reset_error
				if is_open then
					authenticator.try_login
					if is_logged_in then
						if send_transfer_mode_command then
							bytes_transferred := 0
							transfer_initiated := False
							is_count_valid := False
						else
							lio.put_labeled_string ("ERROR", "cannot set transfer mode")
							lio.put_new_line
						end
					else
						lio.put_labeled_string ("ERROR", Invalid_login_error)
						lio.put_new_line
					end
				end
				attempts := attempts + 1
			end
			if not is_logged_in then
				close
			end
		end

	open
			-- Open resource.
		local
			l_socket: like main_socket
		do
			if not is_open then
				open_connection
				if not is_open then
					error_code := Connection_refused
				else
					l_socket := main_socket
					check l_socket_attached: l_socket /= Void end
					receive (l_socket)
				end
			end
		rescue
			error_code := Connection_refused
		end

	quit
			--
		do
			send (Ftp_command.Quit, << 221 >>)
			if is_lio_enabled then
				lio.put_new_line
			end
			if last_succeeded then
				if is_lio_enabled then
					lio.put_line ("QUIT OK")
				end
			else
				lio.put_line ("QUIT command failed")
			end
		end

	set_default_state
		do
			make_default
		end

feature {EL_FTP_AUTHENTICATOR} -- Implementation

	absolute_dir (dir_path: EL_DIR_PATH): EL_DIR_PATH
		do
			if dir_path.is_absolute then
				Result := dir_path
			else
				Result := current_directory.joined_dir_path (dir_path)
			end
		end

	absolute_file_path (file_path: EL_FILE_PATH): EL_FILE_PATH
		do
			if file_path.is_absolute then
				Result := file_path
			else
				Result := current_directory + file_path
			end
		end

	authenticate
			-- Log in to server.
		require
			opened: is_open
		do
			is_logged_in := send_username and then send_password
		end

	get_current_directory: EL_DIR_PATH
		do
			send (Ftp_command.Print_working_directory, << >>)
			Result := last_reply
			Result.change_to_unix
			reply_parser.set_source_text (last_reply)
			reply_parser.do_all
			Result := reply_parser.last_ftp_cmd_result
			Result.change_to_unix
		end

	send (str: ZSTRING; codes: ARRAY [INTEGER])
		do
			send_to_socket (main_socket, str.to_utf_8 (False))
			last_reply_utf_8.right_adjust
			last_reply_utf_8.to_lower
			last_succeeded := reply_code_ok (last_reply_utf_8, codes)
		end

	transfer_file_data (a_file_path: EL_FILE_PATH)
			--
		local
			packet: PACKET; bytes_read: INTEGER
		do
			create packet.make (Default_packet_size)
			if attached open_raw (a_file_path, Read_from) as transfer_file then
				from until transfer_file.after loop
					transfer_file.read_to_managed_pointer (packet.data, 0, packet.count)
					bytes_read := transfer_file.bytes_read
					if bytes_read > 0 then
						if bytes_read /= packet.count then
							packet.data.resize (bytes_read)
						end
						data_socket.write (packet)
					end
				end
				data_socket.close
				is_packet_pending := false
				transfer_file.close
			end
			receive (main_socket)
			if error then
				if is_lio_enabled then
					lio.put_new_line; lio.put_new_line
					lio.put_string_field ("ERROR: Server replied", last_reply)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Internal attributes

	authenticator: EL_FTP_AUTHENTICATOR

feature {NONE} -- Internal attributes

	reply_parser: EL_FTP_REPLY_PARSER

feature {NONE} -- Constants

	Default_packet_size: INTEGER
			--
		once
			Result := 2048
		end

	Default_url: FTP_URL
		once ("PROCESS")
			create Result.make ("")
		end

	Directory_separator: CHARACTER = '/'

	Invalid_login_error: READABLE_STRING_GENERAL
		once
			Result := "Invalid username or password"
		end

	Max_login_attempts: INTEGER
		once
			Result := 2
		end

	Not_regular_file: STRING = "not a regular file"

end