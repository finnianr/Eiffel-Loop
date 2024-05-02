note
	description: "FTP implementation of ${NETWORK_RESOURCE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-02 11:28:20 GMT (Thursday 2nd May 2024)"
	revision: "1"

deferred class
	EL_FTP_NETWORK_RESOURCE

inherit
	NETWORK_RESOURCE
		rename
			error as has_error,
			exception as exception_code,
			Http_end_of_header_line as Carriage_return_new_line
		redefine
			address, is_open, put, read, reuse_connection, make
		end

	EL_FTP_COMMAND_CONSTANTS

feature {NONE} -- Initialization

	make (addr: like address)
		do
			Precursor {NETWORK_RESOURCE} (addr)
			create last_reply.make_empty
		end

feature -- Access

	address: FTP_URL
			-- Associated address

feature -- Measurement

	count: INTEGER
			-- Size of data resource
		do
			if is_count_valid then Result := resource_size end
		end

	resource_size: INTEGER
		-- Cached size of transferred file

feature -- Status report

	Supports_multiple_transactions: BOOLEAN = True
			-- Does resource support multiple transactions per connection?
			-- (Answer: yes)

	is_binary_mode: BOOLEAN
			-- Is binary transfer mode selected?

	is_logged_in: BOOLEAN
			-- Logged in to a server?

	is_open: BOOLEAN
			-- Is resource open?
		local
			l_socket: like main_socket
		do
			if is_proxy_used then
				check attached proxy_connection as l_proxy then
					Result := l_proxy.is_open
				end
			else
				l_socket := main_socket
				Result := (l_socket /= Void) and then not l_socket.is_closed
			end
		end

	passive_mode: BOOLEAN
			-- Is passive mode used?

	read_mode: BOOLEAN
			-- Is read mode set?
		do
			Result := (mode = Read_mode_id)
		end

	valid_mode (n: INTEGER): BOOLEAN
			-- Is mode `n' valid?
		do
			Result := (Read_mode_id <= n) and (n <= Write_mode_id)
		end

	write_mode: BOOLEAN
			-- Is write mode set?
		do
			Result := (mode = Write_mode_id)
		end

feature -- Status setting

	close_sockets
			-- Close.
		do
			if is_proxy_used then
				check attached proxy_connection as l_proxy then
					l_proxy.close
				end
			elseif attached main_socket as l_socket then
				l_socket.close
				main_socket := Void
				if
					attached accepted_socket as l_accepted_socket and then
					(l_accepted_socket.is_open_read or l_accepted_socket.is_open_write)
				then
					l_accepted_socket.close
					accepted_socket := Void
					data_socket := Void
				end
			end
			last_packet := Void
			is_packet_pending := False
			readable_cached := False
			writable_cached := False
			is_logged_in := False
			initiating_listing := False
		ensure then
			not_logged_in: not is_logged_in
		rescue
			error_code := Transmission_error
		end

	reuse_connection (other: FTP_PROTOCOL)
			-- Reuse connection of `other'.
		do
			main_socket := other.main_socket
			data_socket := other.data_socket
			accepted_socket := other.accepted_socket
			proxy_connection := other.proxy_connection
		end

	set_active_mode
			-- Switch FTP client to active mode.
		do
			passive_mode := False
		ensure
			active_mode_set: not passive_mode
		end

	set_binary_mode
			-- Set binary transfer mode.
		do
			is_binary_mode := True
		ensure
			binary_mode_set: is_binary_mode
		end

	set_passive_mode
			-- Switch FTP client to passive mode.
		do
			passive_mode := True
		ensure
			passive_mode_set: passive_mode
		end

	set_read_mode
			-- Set read mode.
		do
			mode := Read_mode_id
		end

	set_text_mode
			-- Set ASCII text transfer mode.
		do
			is_binary_mode := False
		ensure
			text_mode_set: not is_binary_mode
		end

	set_write_mode
	 		-- Set write mode.
		do
			mode := Write_mode_id
		end

feature -- Input/Output operations

	put (other: DATA_RESOURCE)
			-- Write out resource `other'.
		do
			if is_proxy_used then
				check attached proxy_connection as l_proxy then
					l_proxy.put (other)
				end
			else
				from
				until
					has_error or else not other.is_packet_pending
				loop
					if attached accepted_socket as l_socket then
						check_socket (l_socket, Write_only)
						if not has_error then
							other.read
							if attached other.last_packet as l_packet then
								l_socket.put_string (l_packet)
								last_packet_size := l_packet.count
								bytes_transferred := bytes_transferred + last_packet_size
								if last_packet_size /= other.last_packet_size then
									error_code := Write_error
								end
							else
								error_code := read_error
							end
						end
					else
						error_code := no_socket_to_connect
					end
				end
			end
		rescue
			error_code := Write_error
		end

	read
			-- Read packet.
		local
			l_packet: like last_packet
		do
			if is_proxy_used then
				check attached proxy_connection as l_proxy then
					l_proxy.read
				end
			elseif attached accepted_socket as l_socket then
				check_socket (l_socket, Read_only)
				if not has_error then
					l_socket.read_stream (read_buffer_size)
					l_packet := l_socket.last_string
					last_packet := l_packet
					last_packet_size := l_packet.count
					bytes_transferred := bytes_transferred + last_packet_size
					if last_packet_size = 0 then
						is_packet_pending := False
						if attached main_socket as l_main_socket then
							receive (l_socket)
							if reply_code (last_reply) /= Reply.closing_data_connection then
								error_code := Transfer_failed
							end
						else
							error_code := no_socket_to_connect
						end
					end
				end
			else
				error_code := no_socket_to_connect
			end
		rescue
			error_code := Transfer_failed
			last_packet := Void
			last_packet_size := 0
		end

feature {NONE} -- Implementation

	dash_check (str: STRING): BOOLEAN
			-- Check for dash
		require
			string_exists: str /= Void
		local
			s: STRING
		do
			if str.count >= 4 then
				s := str.twin
				s.left_adjust
				if s.count >= 4 then Result := (s.item (4) = '-') end
			end
		end

	has_num (str: STRING): BOOLEAN
			-- Check for response code.
		require
			string_exists: str /= Void
		local
			s: STRING
			i: INTEGER
		do
			if str.count >= 3 then
				s := str.twin
				s.left_adjust
				if s.count >=3 then
					Result := True
					from i := 1 until i = 4 or not Result loop
						if i <= s.count and then not s.item (i).is_digit then
							Result := False
						end
						i := i + 1
					end
				end
			end
		end

	open_connection
			-- Open the connection.
		local
			l_socket: like main_socket
			l_proxy: like proxy_connection
		do
			if is_proxy_used then
				create l_proxy.make (address)
				proxy_connection := l_proxy
				l_proxy.set_timeout (timeout)
			else
				create l_socket.make_client_by_port (address.port, address.host)
				main_socket := l_socket
				l_socket.set_timeout (timeout)
				l_socket.connect
			end
		rescue
			error_code := Connection_refused
		end

	receive (s: NETWORK_SOCKET)
			-- Receive line.
		require
			socket_exists: s /= Void
			socket_readable: s.is_open_read
		local
			l_reply: detachable STRING
			go_on: BOOLEAN
		do
			from
				l_reply := Void
			until
				has_error or else (l_reply /= Void and not go_on)
			loop
				check_socket (s, Read_only)
				if not has_error then
					s.read_line
					create l_reply.make (s.last_string.count + 1)
					l_reply.append (s.last_string)
					l_reply.append_character ('%N')
					debug
						if not l_reply.is_empty then
							io.put_string (l_reply)
						end
					end
					if has_num (l_reply) then
						if dash_check (l_reply) then
							go_on := True
						else
							go_on := False
						end
					end
				end
			end
			if l_reply /= Void then
				last_reply := l_reply
			end
		end

	reply_code (a_reply: STRING): NATURAL_16
		do
			Result := String_8.substring_to (a_reply, ' ').to_natural_16
		end

	set_resource_size (s: STRING)
			-- Extract file size from `s'.
		require
			no_error_occurred: not has_error
			one_parenthesis_pair: s.occurrences ('(') = 1 and then s.occurrences (')') = 1
			parenthesis_match: s.index_of ('(', 1) < s.index_of (')', 1)
		local
			pos: INTEGER; tail: STRING
		do
			pos := s.index_of ('(', 1)
			tail := s.twin
			tail.remove_head (pos)
			pos := tail.index_of (' ', 1)
			tail.keep_head (pos - 1)
			resource_size := tail.to_integer
			if resource_size > 0 then
				is_count_valid := True
			end
		end

	setup_passive_mode_socket (info: like new_data_port_info): NETWORK_STREAM_SOCKET
			-- Create a data socket specified by `a_reply' for the use with
		require
			passive_mode: passive_mode
		do
			create Result.make_client_by_port (info.port_number, info.address)
		ensure
			socket_created_if_no_error: not has_error implies Result /= Void
		rescue
			error_code := Connection_refused
		end

feature {NONE} -- Factory

	new_byte_list (n, num: INTEGER; low_first: BOOLEAN): STRING
			-- A comma-separated representation of the `num' lowest bytes of
			-- `n'
		require
			positive_number_of_bytes: num > 0
		local
			divisor, i, number: INTEGER; str: STRING
		do
			create Result.make (20)
			from divisor := (256 ^ (num - 1)).rounded; number := n until divisor = 0 loop
				i := number // divisor
				number := number - i * divisor
				str := i.out
				if low_first then
					Result.prepend (str)
				else
					Result.append (str)
				end
				if divisor > 1 then
					if low_first then
						Result.prepend (",")
					else
						Result.append (",")
					end
				end
				divisor := divisor // 256
			variant
				divisor
			end
		end

	new_data_port_info: TUPLE [address: STRING; port_number: INTEGER]
		-- "227 entering passive mode (213,171,193,5,210,246)."
		require
			valid_passive_mode_response: last_reply.has ('(') and then last_reply.occurrences (',') = 5
		local
			s: EL_STRING_8_ROUTINES; number_list, l_address: STRING; index, i: INTEGER
			l_port, byte: INTEGER
		do
			number_list := s.substring_to_reversed (last_reply, '(')
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

	new_localhost_port_string (p: INTEGER): STRING
			-- PORT command
		require
			port_positive: p > 0
		local
			af: INET_ADDRESS_FACTORY
		do
			create af
			Result := comma.joined (af.create_localhost.host_address, new_byte_list (p, 2, False))
		end

feature {NONE} -- Internal attributes

	accepted_socket: detachable NETWORK_STREAM_SOCKET
		-- Handle to socket of incoming connection

	data_socket: detachable NETWORK_STREAM_SOCKET
		-- Socket for data connection

	proxy_connection: detachable HTTP_PROTOCOL
		-- Connection to http proxy

	initiating_listing: BOOLEAN
		-- `True' if initiating download of directory entry listing

	last_reply: STRING
		-- Last received server reply

feature {NONE} -- Constants

	Read_mode_id: INTEGER = 1

	Write_mode_id: INTEGER = 2

end