note
	description: "${EL_FTP_PROTOCOL} for Fasthosts.co.uk service"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-02 11:05:03 GMT (Thursday 2nd May 2024)"
	revision: "1"

class
	EL_PROSITE_FTP_PROTOCOL

inherit
	EL_FTP_PROTOCOL
		rename
			receive_entry_list_count as receive_entry_list_response
		redefine
			read_entry_count, receive_entry_list_response
		end

create
	make_write, make_read

feature -- Basic operations

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
		do
			receive (main_socket)
			if reply_code (last_reply) /= Reply.closing_data_connection then
				error_code := Transmission_error
			end
			last_entry_count := list_count
		end

end