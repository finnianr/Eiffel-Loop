note
	description: "Ftp protocol"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "29"

class
	EL_FTP_PROTOCOL

inherit
	FTP_PROTOCOL
		rename
			address as config,
			exception as exception_code,
			send as send_to_socket,
			login as ftp_login,
			last_reply as last_reply_utf_8
		export
			{EL_FTP_AUTHENTICATOR} send_username, send_password
		redefine
			close, open, initialize, config
		end

	EL_FILE_OPEN_ROUTINES
		rename
			Open as File_open,
			Read as Read_from
		end

	EL_MODULE_EXCEPTION

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_FTP_CONSTANTS

create
	make_write, make_read

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create authenticator.make
			create current_directory
			set_binary_mode
			create reply_parser.make
		end

	make_read (a_config: EL_FTP_CONFIGURATION)
		do
			make (a_config)
			set_read_mode
		end

	make_write (a_config: EL_FTP_CONFIGURATION)
		do
			make (a_config)
			set_write_mode
		end

feature -- Access

	authenticator: EL_FTP_AUTHENTICATOR

	config: EL_FTP_CONFIGURATION

	current_directory: DIR_PATH

	last_reply: ZSTRING
		do
			create Result.make_from_utf_8 (last_reply_utf_8)
			Result.right_adjust
		end

	user_home_dir: DIR_PATH
		do
			Result := config.user_home_dir
		end

feature -- Element change

	set_authenticator (a_authenticator: like authenticator)
		do
			authenticator := a_authenticator
		end

	set_current_directory (a_current_directory: DIR_PATH)
		do
			send (Template.change_working_directory #$ [absolute_unix_dir (a_current_directory)], << 200, 250 >>)
			if last_succeeded then
				if a_current_directory.is_absolute then
					current_directory := a_current_directory
				else
					current_directory := current_directory #+ a_current_directory
				end
			end
		ensure
			changed: get_current_directory ~ current_directory
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
			set_current_directory (user_home_dir)
		end

	delete_file (file_path: FILE_PATH)
		do
			send (Template.delete_file #$ [file_path.to_unix], << 250 >>)
		end

	make_directory (dir_path: DIR_PATH)
			-- Create directory relative to current directory
		require
			dir_path_is_relative: not dir_path.is_absolute
		local
			parent_dir: DIR_PATH; parent_exists: BOOLEAN
		do
			if not directory_exists (dir_path) then
				parent_dir := dir_path.parent
				parent_exists := directory_exists (parent_dir)
				if not parent_exists then
					make_directory (parent_dir)
					parent_exists := last_succeeded
				end
				if parent_exists then
					make_sub_directory (dir_path)
				end
			end
		ensure
			exists: directory_exists (dir_path)
		end

	remove_directory (dir_path: DIR_PATH)
		do
			send (Template.remove_directory #$ [absolute_unix_dir (dir_path)], << 250 >>)
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
			transfer_file (item.source_path, item.destination_file_path)
		rescue
			lio.put_new_line
			lio.put_labeled_string ("Socket error", data_socket.error)
			lio.put_new_line
			lio.put_labeled_string ("Description", Exception.last_exception.description)
			lio.put_new_line
			close; reset_error
			is_retry := True
			retry
		end

feature -- Status report

	directory_exists (dir_path: DIR_PATH): BOOLEAN
			-- Does remote directory exist
		do
			if dir_path.is_empty then
				Result := True
			else
				send (Template.size #$ [absolute_unix_dir (dir_path)], << 550 >>)
				Result := last_succeeded and then last_reply_utf_8.has_substring (Not_regular_file)
			end
		end

	file_exists (file_path: FILE_PATH): BOOLEAN
			-- Does remote directory exist
		do
			if file_path.is_empty then
				Result := True
			else
				send (Template.size #$ [absolute_unix_file_path (file_path)], << 213 >>)
				Result := last_succeeded
			end
		end

	has_error: BOOLEAN
		do
			Result := not last_succeeded
		end

	is_default_state: BOOLEAN
		do
			Result := config.url ~ Default_url
		end

	last_succeeded: BOOLEAN

feature -- Status change

	close
			--
		do
			if transfer_initiated then
				data_socket.close
				transfer_initiated := False
			end
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
					authenticator.try_login (Current)
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
			send (Command.quit, << 221 >>)
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
			initialize
		end

feature {EL_FTP_AUTHENTICATOR} -- Implementation

	absolute_unix_dir (dir_path: DIR_PATH): ZSTRING
		do
			if dir_path.is_absolute then
				Result := dir_path.to_unix
			else
				Result := (current_directory #+ dir_path).to_unix
			end
		end

	absolute_unix_file_path (file_path: FILE_PATH): ZSTRING
		do
			if file_path.is_absolute then
				Result := file_path.to_unix
			else
				Result := (current_directory + file_path).to_unix
			end
		end

	authenticate
			-- Log in to server.
		require
			opened: is_open
		do
			is_logged_in := send_username and then send_password
		end

	get_current_directory: DIR_PATH
		do
			send (Command.print_working_directory, << >>)
			Result := last_reply
			reply_parser.set_source_text (last_reply)
			reply_parser.do_all
			Result := reply_parser.last_ftp_cmd_result
		end

	make_sub_directory (dir_path: DIR_PATH)
		require
			parent_exists: directory_exists (dir_path.parent)
		do
			send (Template.make_directory #$ [dir_path.to_unix], << 257 >>)
		end

	send (str: ZSTRING; codes: ARRAY [INTEGER])
		do
			send_to_socket (main_socket, str.to_utf_8 (False))
			last_reply_utf_8.right_adjust
			last_reply_utf_8.to_lower
			last_succeeded := reply_code_ok (last_reply_utf_8, codes)
		end

	transfer_file (source_path, destination_path: FILE_PATH)
		do
			config.path.share (destination_path.to_unix.to_utf_8 (True))
			set_passive_mode
			initiate_transfer
			if transfer_initiated then
				transfer_file_data (source_path)
				transfer_initiated := false
			else
				Exception.raise_developer ("Failed to initiate transfer: %S", [source_path.base])
			end
		ensure
			data_socket_close: data_socket.is_closed
		end

	transfer_file_data (a_file_path: FILE_PATH)
			--
		local
			packet: PACKET; bytes_read: INTEGER
		do
			create packet.make (Default_packet_size)
			if attached open_raw (a_file_path, Read_from) as file then
				from until file.after loop
					file.read_to_managed_pointer (packet.data, 0, packet.count)
					bytes_read := file.bytes_read
					if bytes_read > 0 then
						if bytes_read /= packet.count then
							packet.data.resize (bytes_read)
						end
						data_socket.write (packet)
					end
				end
				data_socket.close
				is_packet_pending := false
				file.close
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

	reply_parser: EL_FTP_REPLY_PARSER

end