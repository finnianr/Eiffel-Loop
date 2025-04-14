note
	description: "${NETWORK_STREAM_SOCKET} for file transfer protocol (FTP)"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-14 7:42:59 GMT (Monday 14th April 2025)"
	revision: "6"

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
			resource := a_resource
			make_client_by_port (a_resource.address.port, a_resource.address.host)
		end

	make_data (a_resource: EL_FTP_NETWORK_RESOURCE; port_specification: STRING)
		-- parse specification from ftp reply like: "227 entering passive mode (213,171,193,5,210,246)."
		require
			valid_port_specification: port_specification.has ('(') and then port_specification.occurrences (',') = 5
		local
			sg: EL_STRING_GENERAL_ROUTINES; number_list, ip_address: STRING; index, i: INTEGER
			port_number, byte: INTEGER
		do
			resource := a_resource
			number_list := sg.super_8 (port_specification).substring_to_reversed ('(')
			index := number_list.last_index_of (')', number_list.count)
			if index > 0 then
				number_list.keep_head (index - 1)
				index := number_list.count
				from i := 0 until i > 8 loop
					byte := sg.super_8 (number_list).substring_to_reversed_from (',', $index).to_integer
					port_number := port_number | (byte |<< i)
					i := i + 8
				end
				ip_address := number_list.substring (1, index)
				sg.super_8 (ip_address).replace_character (',', '.')
			else
				create ip_address.make_empty
			end
			make_client_by_port (port_number, ip_address)
		end

	make_server (a_resource: EL_FTP_NETWORK_RESOURCE)
		do
			resource := a_resource
			make_server_by_port (0)
		end

feature -- Status query

	has_error: BOOLEAN
		do
			Result := resource.has_error
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
				data.set_from_pointer (default_pointer, 0)
			end
			get_reply (reply_out)
			reply_out.adjust; reply_out.to_lower
		end

	get_reply (reply_out: STRING)
		require
			socket_readable: is_open_read
		local
			go_on: BOOLEAN; received: BOOLEAN
		do
			reply_out.wipe_out
			from until has_error or else (reply_out.count > 0 and not go_on) loop
				if ready_for_reading then
					read_line
					reply_out.append (last_string)
					reply_out.append (Carriage_return_new_line)
					go_on := is_multi_line (last_string)
					received := True
				else
					resource.set_connection_timeout_error
				end
			end
			if not received then
				resource.set_transmission_error
			end
		end

feature {NONE} -- Implementation

	is_multi_line (str: STRING): BOOLEAN
		-- check for dash character in 4th position after leading whitespace
		-- indicating a multi-line message such as:

		-- 	220-FTP Server Ready
		-- 	220-Please note the following:
		-- 	220-Welcome to the server.
		-- 	220 Some final note.
		do
			if has_response_code (str) then
				Result := str.valid_index (4) and then str [4] = '-'
			end
		end

	has_response_code (str: STRING): BOOLEAN
		-- `True' if `str' starts with 3 digits
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