note
	description: "FTP implementation of ${NETWORK_RESOURCE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-14 7:50:12 GMT (Tuesday 14th May 2024)"
	revision: "6"

deferred class
	EL_FTP_NETWORK_RESOURCE

inherit
	NETWORK_RESOURCE
		rename
			error as has_error,
			exception as exception_code,
			Http_end_of_header_line as Carriage_return_new_line
		redefine
			address, is_open, put, read, reuse_connection, make, main_socket
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
			if is_count_valid then
				Result := resource_size
			end
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
		do
			if is_proxy_used then
				check attached proxy_connection as l_proxy then
					Result := l_proxy.is_open
				end
			elseif attached main_socket as socket then
				Result := (socket /= Void) and then not socket.is_closed
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

feature -- Error setting

	set_transmission_error
		do
			error_code := Transmission_error
		end

	set_connection_timeout_error
		do
			error_code := Connection_timeout
		end

feature -- Status setting

	close_sockets
			-- Close.
		do
			if is_proxy_used then
				check attached proxy_connection as l_proxy then
					l_proxy.close
				end
			elseif attached main_socket as socket then
				socket.close
				main_socket := Void
				if attached accepted_socket as accepted
					and then (accepted.is_open_read or accepted.is_open_write)
				then
					accepted.close
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

	reuse_connection (other: EL_FTP_NETWORK_RESOURCE)
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
				from until has_error or else not other.is_packet_pending loop
					if attached accepted_socket as socket then
						check_socket (socket, Write_only)
						if not has_error then
							other.read
							if attached other.last_packet as l_packet then
								socket.put_string (l_packet)
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
			l_packet: like last_packet; code: NATURAL_16
		do
			if is_proxy_used then
				check attached proxy_connection as l_proxy then
					l_proxy.read
				end
			elseif attached accepted_socket as socket then
				check_socket (socket, Read_only)
				if not has_error then
					socket.read_stream (read_buffer_size)
					l_packet := socket.last_string
					last_packet := l_packet
					last_packet_size := l_packet.count
					bytes_transferred := bytes_transferred + last_packet_size
					if last_packet_size = 0 then
						is_packet_pending := False
						socket.get_reply (last_reply)
						if not has_error then
							code := last_reply_code
							if code > 0 and then code /= Reply.closing_data_connection then
								error_code := Transfer_failed
							end
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

	open_connection
			-- Open the connection.
		local
			l_proxy: like proxy_connection
		do
			if is_proxy_used then
				create l_proxy.make (address)
				proxy_connection := l_proxy
				l_proxy.set_timeout (timeout)
			else
				create main_socket.make_control (Current)
				if attached main_socket as socket then
					socket.set_timeout (timeout)
					socket.connect
				end
			end
		rescue
			error_code := Connection_refused
		end

	last_reply_code: NATURAL_16
		do
			if attached last_reply as l_reply and then l_reply.count > 0 and then l_reply [1].is_digit then
				Result := String_8.substring_to (l_reply, ' ').to_natural_16
			end
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

	new_data_socket: EL_FTP_STREAM_SOCKET
			-- Create a data socket specified by `a_reply' for the use with
		require
			passive_mode: passive_mode
		do
			create Result.make_data (Current, last_reply)
		rescue
			error_code := Connection_refused
		end

feature {EL_FTP_NETWORK_RESOURCE} -- Internal attributes

	accepted_socket: detachable EL_FTP_STREAM_SOCKET
		-- Handle to socket of incoming connection

	data_socket: detachable EL_FTP_STREAM_SOCKET
		-- Socket for data connection

	proxy_connection: detachable HTTP_PROTOCOL
		-- Connection to http proxy

	initiating_listing: BOOLEAN
		-- `True' if initiating download of directory entry listing

	last_reply: STRING
		-- Last received server reply

	main_socket: detachable EL_FTP_STREAM_SOCKET

feature {NONE} -- Constants

	Read_mode_id: INTEGER = 1

	Write_mode_id: INTEGER = 2

end