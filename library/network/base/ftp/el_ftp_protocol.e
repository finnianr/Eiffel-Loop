note
	description: "FTP protocol"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-28 13:18:00 GMT (Sunday 28th April 2024)"
	revision: "41"

class
	EL_FTP_PROTOCOL

inherit
	EL_FTP_IMPLEMENTATION
		redefine
			open, initialize
		end

create
	make_write, make_read

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create current_directory
			set_binary_mode
			create created_directory_set.make (10)
			create reply_parser.make
		end

	make (a_config: EL_FTP_CONFIGURATION; set_mode: PROCEDURE)
		require
			authenticated: a_config.is_authenticated
		do
			make_ftp (a_config.url)
			config := a_config
			passive_mode := a_config.passive_mode
			set_mode.apply
		end

	make_read (a_config: EL_FTP_CONFIGURATION)
		do
			make (a_config, agent set_read_mode)
		end

	make_write (a_config: EL_FTP_CONFIGURATION)
		do
			make (a_config, agent set_write_mode)
		end

feature -- Access

	config: EL_FTP_CONFIGURATION

	current_directory: DIR_PATH

	entry_list (dir_path: DIR_PATH): EL_FILE_PATH_LIST
		-- list of file and directory entries in remote directory `dir_path'
		local
			line_list: EL_SPLIT_IMMUTABLE_UTF_8_LIST
		do
			create Result.make_empty
			initiate_file_listing (dir_path)

			if transfer_initiated then
				from until data_socket.is_closed loop
					read
					create line_list.make_shared_by_string (last_packet, Carriage_return_new_line)
					if attached line_list as list then
						Result.grow (Result.count + list.count)
						from list.start until list.after loop
							if list.utf_8_item_count = 0 then
								data_socket.close
							else
								Result.extend (dir_path + list.item)
							end
							list.forth
						end
					end
					receive_entry_list_count
				end
			end
			reset_file_listing
		ensure
			valid_count: Result.count = last_entry_count
			address_path_unchanged: old address.path ~ address.path
			detached_data_socket: not attached data_socket
		end

	last_reply: ZSTRING
		do
			create Result.make_from_utf_8 (last_reply_utf_8)
			Result.right_adjust
		end

	user_home_dir: DIR_PATH
		do
			Result := config.user_home_dir
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

feature -- Element change

	set_current_directory (a_current_directory: DIR_PATH)
		do
			send_absolute (
				Command.change_working_directory, a_current_directory, << Reply.success, Reply.file_action_ok >>
			)
			if last_succeeded then
				if a_current_directory.is_absolute then
					current_directory.copy (a_current_directory)
				else
					current_directory.append_dir_path (a_current_directory)
				end
			end
		ensure
			changed: get_current_directory ~ current_directory
		end

feature -- Remote operations

	change_home_dir
		do
			set_current_directory (user_home_dir)
		end

	delete_file (file_path: FILE_PATH)
		do
			send_path (Command.delete_file, file_path, << Reply.file_action_ok >>)
		end

	make_directory (dir_path: DIR_PATH)
		-- create directory relative to current directory
		require
			dir_path_is_relative: not dir_path.is_absolute
		do
			if dir_path.is_empty or directory_exists (dir_path) then
				do_nothing
			else
				if attached dir_path.parent as parent and then not directory_exists (parent) then
					make_directory (parent) -- recurse
				end
				make_directory_step (dir_path)
			end
		ensure
			exists: directory_exists (dir_path)
		end

	remove_directory (dir_path: DIR_PATH)
		do
			send_absolute (Command.remove_directory, dir_path, << Reply.file_action_ok >>)
			if last_succeeded then
				created_directory_set.prune (dir_path)
			end
		end

	remove_until_empty (dir_path: DIR_PATH)
		local
			done: BOOLEAN; l_path: DIR_PATH
		do
			from l_path := dir_path.twin until done loop
				read_entry_count (l_path)
				if last_entry_count = 0 then
					remove_directory (l_path)
					l_path := l_path.parent
					done := l_path.is_empty
				else
					done := True
				end
			end
		end

feature -- Basic operations

	read_entry_count (dir_path: DIR_PATH)
		do
			initiate_file_listing (dir_path)
			if transfer_initiated then
				data_socket.close
				receive_entry_list_count
			end
			reset_file_listing
		ensure
			address_path_unchanged: old address.path ~ address.path
			detached_data_socket: not attached data_socket
		end

	reset
		do
			close; reset_error
			execution.sleep (500)
			login; change_home_dir
		end

	upload (item: EL_FTP_UPLOAD_ITEM)
		-- upload file to destination directory relative to home directory
		require
			binary_mode_set: is_binary_mode
			file_to_upload_exists: item.source_path.exists
		do
			make_directory (item.destination_dir)
			transfer_file (item.source_path, item.destination_file_path)
		end

feature -- Status query

	directory_exists (dir_path: DIR_PATH): BOOLEAN
		-- `True' if remote directory `dir_path' exists relative to `current_directory'
		do
			if dir_path.is_empty or else created_directory_set.has (dir_path) then
				Result := True
			else
				send_absolute (Command.size, dir_path, << Reply.action_not_taken >>)
				Result := last_succeeded and then last_reply_utf_8.has_substring (Error.not_regular_file)
			end
		end

	file_exists (file_path: FILE_PATH): BOOLEAN
		-- `True' if remote `file_path' exists relative to `current_directory'
		do
			if file_path.is_empty then
				Result := True
			else
				send_absolute (Command.size, file_path, << Reply.file_status >>)
				Result := last_succeeded
			end
		end

	is_default_state: BOOLEAN
		do
			Result := config.url.host.is_empty
		end

	last_succeeded: BOOLEAN
		do
			Result := error_code = 0
		end

feature -- Status change

	close
			--
		do
			if is_logged_in then
				quit
			end
			close_sockets
		end

	login
		do
			if not is_open then
				open
			end
			attempt (agent try_login, Max_login_attempts)

			if not is_logged_in then
				close
			end
		end

	try_login (done: BOOLEAN_REF)
		do
			reset_error
			if is_open then
				authenticate
				if is_logged_in then
					done.set_item (True)
					if send_transfer_mode_command then
						bytes_transferred := 0
						transfer_initiated := False
						is_count_valid := False
					else
						display_error (Error.cannot_set_transfer_mode)
					end
				else
					display_error (Error.invalid_login)
				end
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
--					if error_code = 0 and passive_mode then
--						if not send_passive_mode_command and then error_code = Wrong_command then
--							display_error (Error.cannot_enter_passive_mode)
--						end
--					end
				end
			end
		rescue
			error_code := Connection_refused
		end

	quit
			--
		do
			send (Command.quit, Void, << Reply.closing_control_connection >>)
		end

	set_default_state
		do
			initialize
		end

feature {NONE} -- Implementation

	authenticate
		-- Log in to server.
		require
			opened: is_open
		do
			is_logged_in := send_username and then send_password
		end

	get_current_directory: DIR_PATH
		do
			send (Command.print_working_directory, Void, << Reply.PATHNAME_created >>)
			-- 257 %"/htdocs%" is your current location%R%N
			if last_succeeded then
				Result := last_reply.cropped ('"', '"')
			else
				create Result
			end
		end

	make_directory_step (dir_path: DIR_PATH)
		require
			parent_exists: directory_exists (dir_path.parent)
		do
			send_path (Command.make_directory, dir_path, << Reply.PATHNAME_created >>)
			if last_succeeded then
				created_directory_set.put (dir_path)
			end
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

	set_last_entry_count (a_count: INTEGER)
		do
			last_entry_count := a_count
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

end