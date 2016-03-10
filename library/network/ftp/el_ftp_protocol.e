note
	description: "Summary description for {EL_FTP_PROTOCOL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "7"

class
	EL_FTP_PROTOCOL

inherit
	FTP_PROTOCOL
		export
			{ANY} send_username, send_password
		redefine
			make, close, open
		end

	EL_TRANSFER_COMMAND_CONSTANTS
		undefine
			is_equal
		end

	EL_MODULE_LOG
		undefine
			is_equal
		end

	EL_TEXTUAL_PATTERN_FACTORY
		undefine
			is_equal
		end

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			make (create {FTP_URL}.make (""))
		end

	make (addr: like address)
			-- Create protocol.
		do
			Precursor (addr)
			create reply_parser.make_with_delimiter (ftp_reply_pattern)
		end

feature -- Access

	home_directory: EL_DIR_PATH

	current_directory: EL_DIR_PATH
			--
		do
			send (main_socket, Ftp_print_working_directory)
			Result := last_reply
			Result.change_to_unix
			reply_parser.set_source_text (last_reply)
			reply_parser.do_all
			Result := last_ftp_cmd_result
			Result.change_to_unix
		end

feature -- Element change

	set_home_directory (a_home_directory: like home_directory)
			-- Set `home_directory' to `a_home_directory'.
		do
			home_directory := a_home_directory
		end

feature -- Basic operations

	upload_file (a_file_path: EL_FILE_PATH; destination_directory: EL_DIR_PATH)
			-- upload file to destination directory relative to home directory
		require
			binary_mode_set: is_binary_mode
			file_to_upload_exists: a_file_path.exists
		local
			destination_file_path: ASTRING
		do
			log.enter_with_args ("upload_file", << a_file_path, destination_directory >>)

			if not home_directory.joined_dir_path (destination_directory).exists then
				create_directory (destination_directory)
			end

			destination_file_path := home_directory + (destination_directory + a_file_path.base).to_string

			address.path.share (destination_file_path)

			set_passive_mode
			initiate_transfer
			if transfer_initiated then
				transfer_file_data (a_file_path)
				transfer_initiated := false
			else
				log_or_io.put_line ("Could not initiate transfer")
			end
			log.exit
		ensure
			data_socket_close: data_socket.is_closed
		end

	upload (file_and_destination_paths: LIST [like Type_source_destination])
			--
		require
			is_open: is_open
			is_logged_in: is_logged_in
		local
			file_path: EL_FILE_PATH
			destination_path: EL_DIR_PATH
		do
			across file_and_destination_paths as tuple loop
				file_path := tuple.item.source_path
				destination_path := tuple.item.destination_path
				log_or_io.put_path_field ("Uploading", file_path)
				log_or_io.put_new_line
				upload_file (file_path, destination_path)
			end
		end

	create_directory (dir_path: EL_DIR_PATH)
			-- Create directory relative to home directory
		local
			status, directory_exists, is_directory_created: BOOLEAN
			new_dir_path, cur_directory: EL_DIR_PATH
		do
			log.enter_with_args ("create_directory", << dir_path >>)
			cur_directory := current_directory
			new_dir_path := home_directory
			across dir_path.steps as step loop
				new_dir_path := new_dir_path.joined_dir_path (step.item)
				directory_exists := send_change_directory_command (new_dir_path)
				if not directory_exists then
					is_directory_created := send_make_directory_command (new_dir_path)
				end
			end
			status := send_change_directory_command (cur_directory)
			log.exit
		end

	send_make_directory_command (new_dir_path: EL_DIR_PATH): BOOLEAN
			--
		local
			cmd: STRING
		do
			cmd := Ftp_make_directory.twin
			cmd.extend (' ')
			cmd.append (new_dir_path.as_unix.to_string)
			send (main_socket, cmd)
			Result := reply_code_ok (last_reply, << 257 >>)
		end

feature -- Status report

	exists (dir_path: EL_DIR_PATH): BOOLEAN
			-- Does remote directory exist
		local
			remote_directory: like current_directory
			status: BOOLEAN
		do
			remote_directory := current_directory
			Result := send_change_directory_command (dir_path)
			status := send_change_directory_command (remote_directory)
		end

feature -- Status setting

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

	try_login
			-- Log in to server.
		require
			opened: is_open
		do
			if send_username and then send_password and then send_transfer_mode_command then
				bytes_transferred := 0
				transfer_initiated := False
				is_count_valid := False
				is_logged_in := True
			else
				close
			end
		end

	quit
			--
		do
			send (main_socket, Ftp_quit)
			log.put_new_line
			if reply_code_ok (last_reply, << 221 >>) then
				log_or_io.put_line ("QUIT OK")
			else
				log_or_io.put_line ("QUIT command failed")
			end
		end

	close
			--
		do
			if is_logged_in then
				quit
			end
			Precursor
		end

	send_change_directory_command (dir_path: EL_DIR_PATH): BOOLEAN
			--
		local
			cmd: STRING
		do
			cmd := Ftp_change_working_directory.twin
			cmd.extend (' ')
			cmd.append (dir_path.to_unix.to_string)
			send (main_socket, cmd)
			Result := reply_code_ok (last_reply, << 200, 250 >>)
		end

feature -- Type definitions

	Type_source_destination: TUPLE [source_path: EL_FILE_PATH; destination_path: EL_DIR_PATH]
		once
		end

feature {NONE} -- Implementation

	transfer_file_data (a_file_path: EL_FILE_PATH)
			--
		local
			transfer_file: RAW_FILE
			packet: PACKET
			transfered_count, bytes_read: INTEGER
			transfered_mb, total_mb: DOUBLE
			format_mb: FORMAT_DOUBLE
			template: ASTRING
			total_mb_string: STRING
		do
			log.enter_with_args ("transfer_file_data", << a_file_path >>)
			create format_mb.make (4, 1)
			template := "[$S mb of $S mb]%R"
			create packet.make (Default_packet_size)
			create transfer_file.make_open_read (a_file_path.unicode)
			total_mb := transfer_file.count / 1000000
			total_mb_string := format_mb.formatted (total_mb); total_mb_string.left_adjust

			from until transfer_file.after loop
				transfer_file.read_to_managed_pointer (packet.data, 0, packet.count)
				bytes_read := transfer_file.bytes_read
				if bytes_read > 0 then
					if bytes_read /= packet.count then
						packet.data.resize (bytes_read)
					end
					data_socket.write (packet)
				end
				transfered_count := transfered_count + bytes_read
				transfered_mb := transfered_count / 1000000
				log_or_io.put_string (template #$ [format_mb.formatted (transfered_mb), total_mb_string])
			end
			data_socket.close
			is_packet_pending := false
			transfer_file.close
			receive (main_socket)
			last_reply.right_adjust

			log_or_io.put_new_line
			log_or_io.put_new_line
			log_or_io.put_string_field ("Server replied", last_reply)
			log_or_io.put_new_line
			log.exit
		end

feature {NONE} -- Implementation: attributes

	last_ftp_cmd_result: STRING

	last_reply_code: INTEGER

feature {NONE} -- Implementation: parsing

	ftp_reply_pattern: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				start_of_line,
				integer |to| agent on_reply_code,
				optional (all_of (<< non_breaking_white_space, quoted_string_pattern >> ))
			>> )
		end

	quoted_string_pattern: EL_MATCH_ALL_IN_LIST_TP
			-- Quoted string with embedded double-quotes escaped by double-quotes
		do
			Result := all_of (<<
				double_quote,
				zero_or_more (
					one_of ( << string_literal ("%"%""), not double_quote >> )
				) |to| agent on_ftp_cmd_result,

				double_quote
			>> )
		end

	double_quote: EL_LITERAL_CHAR_TP
			--
		do
			create Result.make ({ASCII}.Doublequote.to_natural_32)
		end

	on_reply_code (reply_code_str: EL_STRING_VIEW)
			--
		do
			last_reply_code := reply_code_str.to_string_8.to_integer
		end

	on_ftp_cmd_result (quoted_text: EL_STRING_VIEW)
			--
		do
			last_ftp_cmd_result := quoted_text
		end

	reply_parser: EL_SOURCE_TEXT_PROCESSOR


feature {NONE} -- Constants

	Default_packet_size: INTEGER
			--
		once
			Result := 2048
		end

	Directory_separator: CHARACTER = '/'

end
