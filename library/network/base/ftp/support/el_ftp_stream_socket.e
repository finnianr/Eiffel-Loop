note
	description: "${NETWORK_STREAM_SOCKET} for file transfer protocol (FTP)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-13 13:18:59 GMT (Monday 13th May 2024)"
	revision: "2"

class
	EL_FTP_STREAM_SOCKET

inherit
	NETWORK_STREAM_SOCKET
		export
			{NONE} all
			{ANY} accept, accepted, close, connect, is_closed, is_open_write, is_open_read,
				last_string, listen, port, put_string, read_stream, set_timeout, write
		end

	TRANSFER_COMMAND_CONSTANTS
		rename
			Http_end_of_header_line as Carriage_return_new_line
		end

create
	make_control, make_data, make_server

feature {NONE} -- Initialization

	make_control (a_resource: EL_FTP_NETWORK_RESOURCE)
		do
			make_client_by_port (a_resource.address.port, a_resource.address.host)
			resource := a_resource
		end

	make_server (a_resource: EL_FTP_NETWORK_RESOURCE)
		do
			make_server_by_port (0)
			resource := a_resource
		end

	make_data (a_resource: EL_FTP_NETWORK_RESOURCE; port_specification: STRING)
		require
			valid_port_specification: port_specification.has ('(') and then port_specification.occurrences (',') = 5
		do
			if attached new_data_port_info (port_specification) as info then
				make_client_by_port (info.port_number, info.address)
			end
			resource := a_resource
		end

feature -- Basic operations

	do_command (parts: ARRAY [STRING]; reply_out: STRING)
		do
			if attached Packet_buffer.empty as buffer and then attached Packet_data as data then
				across parts as list loop
					if buffer.count > 0 then
						buffer.append_character (' ')
					end
					buffer.append (list.item)
				end
				buffer.append (Carriage_return_new_line)
				data.set_from_pointer (buffer.area.base_address, buffer.count)
				put_managed_pointer (data, 0, buffer.count)

				get_reply (reply_out)
				reply_out.adjust; reply_out.to_lower
			end
		end

	get_reply (reply_out: STRING)
		require
			socket_readable: is_open_read
		local
			go_on: BOOLEAN; received: BOOLEAN
		do
			reply_out.wipe_out
			from until resource.has_error or else (reply_out.count > 0 and not go_on) loop
				resource.check_socket (Current, resource.Read_only)
				if not resource.has_error then
					read_line
					reply_out.wipe_out
					reply_out.append (last_string)
					reply_out.append (Carriage_return_new_line)
					received := True

					if has_response_code (reply_out) then
						if dash_check (reply_out) then
							go_on := True
						else
							go_on := False
						end
					end
				end
			end
			if not received then
				resource.set_transmission_error
			end
		end

feature {NONE} -- Implementation

	dash_check (str: STRING): BOOLEAN
		-- check for dash character in 4th position after leading whitespace
		local
			s: EL_STRING_8_ROUTINES; space_count: INTEGER
		do
			space_count := s.leading_space_count (str)
			if str.count - space_count >= 4 then
				Result := str [space_count + 4] = '-'
			end
		end

	has_response_code (str: STRING): BOOLEAN
			-- Check for response code.
		local
			i, digit_count: INTEGER; break: BOOLEAN
		do
			Result := True
			from i := 1 until i > str.count or break loop
				if str [i].is_digit then
					digit_count := digit_count + 1
				else
					break := True
				end
				i := i + 1
			end
			Result := digit_count = 3
		end

	new_data_port_info (port_specification: STRING): TUPLE [address: STRING; port_number: INTEGER]
		-- "227 entering passive mode (213,171,193,5,210,246)."
		local
			s: EL_STRING_8_ROUTINES; number_list, l_address: STRING; index, i: INTEGER
			l_port, byte: INTEGER
		do
			number_list := s.substring_to_reversed (port_specification, '(')
			index := number_list.last_index_of (')', number_list.count)
			if index > 0 then
				number_list.keep_head (index - 1)
				index := number_list.count
				from i := 0 until i > 8 loop
					byte := s.substring_to_reversed_from (number_list, ',', $index).to_integer
					l_port := l_port | (byte |<< i)
					i := i + 8
				end
				l_address := number_list.substring (1, index)
				s.replace_character (l_address, ',', '.')
				Result := [l_address, l_port]
			else
				Result := ["", l_port]
			end
		end

feature {NONE} -- Internal attributes

	resource: EL_FTP_NETWORK_RESOURCE

feature {NONE} -- Buffers

	Packet_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

	Packet_data: MANAGED_POINTER
		once
			create Result.share_from_pointer (default_pointer, 0)
		end

end