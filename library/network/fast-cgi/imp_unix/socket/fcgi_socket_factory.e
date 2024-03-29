note
	description: "Unix implemenation of socket factory for FCGI service"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-16 9:56:59 GMT (Friday 16th February 2024)"
	revision: "4"

deferred class
	FCGI_SOCKET_FACTORY

inherit
	EL_PROTOCOL_CONSTANTS

feature -- Factory

	new_client_socket: EL_STREAM_SOCKET
		do
			if server_port > 0 then
				create {EL_NETWORK_STREAM_SOCKET} Result.make_client_by_port (server_port, Localhost)
			else
				create {EL_UNIX_STREAM_SOCKET} Result.make_client (server_socket_path.to_string)
			end
		end

	new_socket: EL_STREAM_SOCKET
		local
			unix_sock: EL_UNIX_STREAM_SOCKET
		do
			if server_port > 0 then
				create {EL_NETWORK_STREAM_SOCKET} Result.make_server_by_port (server_port)
			else
				create unix_sock.make_server (server_socket_path)
				unix_sock.add_permission ("g", "+w")
				Result := unix_sock
			end
		end

feature {NONE} -- Implementation

	server_port: INTEGER
		-- Port server is listening on
		deferred
		end

	server_socket_path: FILE_PATH
		-- Unix socket path to listen on
		deferred
		end

end