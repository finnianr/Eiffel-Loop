note
	description: "${EL_FTP_PROTOCOL} for Fasthosts.co.uk service"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-13 13:12:47 GMT (Monday 13th May 2024)"
	revision: "4"

class
	EL_PROSITE_FTP_PROTOCOL

inherit
	EL_FTP_PROTOCOL
		rename
			receive_entry_list_count as receive_entry_list_response
		redefine
			directory_exists, make_directory, read_entry_count, receive_entry_list_response
		end

create
	make_write, make_read

feature -- Status query

	directory_exists (dir_path: DIR_PATH): BOOLEAN
		-- `True' if remote directory `dir_path' exists relative to `current_directory'
		do
			if dir_path.is_empty or else created_directory_set.has (dir_path) then
				Result := True
			else
				read_entry_count (dir_path)
				Result := last_entry_count >= 0
			end
		end

feature -- Basic operations

	make_directory (dir_path: DIR_PATH)
		-- create directory relative to current directory
		local
			done: BOOLEAN
		do
			if dir_path.is_empty or else created_directory_set.has (dir_path) then
				do_nothing
			else
				from until done loop
					send_path (Command.make_directory, dir_path, << Reply.PATHNAME_created, Reply.action_not_taken >>)
					if last_succeeded then
						if last_reply_code = Reply.action_not_taken then
							if reply_contains (Response.directory_already_exists) then
								created_directory_set.put (dir_path)
								done := True

							elseif reply_contains (Response.parent_does_not_exist) then
								reset_error
								make_directory (dir_path.parent) -- recurse
							end
						else
							created_directory_set.put (dir_path)
							done := True
						end

					else
						done := True
					end
				end
			end
		end

	read_entry_count (dir_path: DIR_PATH)
		do
			initiate_file_listing (dir_path)
			if transfer_initiated and then attached data_socket as socket then
				from until socket.is_closed loop
					read
					socket.close
					receive_entry_list_response (last_packet.occurrences ('%N') - 2)
				end
				reset_file_listing
			end
		end

feature {NONE} -- Implementation

	receive_entry_list_response (list_count: INTEGER)
		-- "226 Closing data connection.%R%N"
		local
			code: NATURAL_16
		do
			if attached main_socket as socket then
				socket.get_reply (last_reply_utf_8)
				if not has_error then
					code := last_reply_code
					if code = Reply.closing_data_connection then
						do_nothing

				-- if for example both steps of path "W_code/C1" do not exist
					elseif code = Reply.action_not_taken
						and then not reply_contains (Response.entry_not_found)
					then
						error_code := Transmission_error
					end
					last_entry_count := list_count
				end
			else
				error_code := No_socket_to_connect
			end
		end

feature {NONE} -- Constants

	Response: TUPLE [
		directory_already_exists, entry_not_found, not_regular_file, parent_does_not_exist: IMMUTABLE_STRING_8
	]
		-- variation of reponses to `Command.size' for a directory
		-- Eg. 550 file not found (/htdocs/w_code/c1).
		once
			create Result
			Tuple.fill_immutable (Result,"[
				directory already exists, entry not found, not a regular file, parent directory does not exist
			]")
		end

end