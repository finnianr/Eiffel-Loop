note
	description: "Windows implemenation of socket factory for FCGI service"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-20 9:39:38 GMT (Monday 20th May 2024)"
	revision: "5"

deferred class
	FCGI_SOCKET_FACTORY

inherit
	EL_PROTOCOL_CONSTANTS

feature -- Access

	server_port: INTEGER
		-- Port server is listening on
		deferred
		end

feature -- Factory

	new_client_socket: EL_STREAM_SOCKET
		require
			valid_server_port: server_port > 0
		do
			create {EL_NETWORK_STREAM_SOCKET} Result.make_client_by_port (server_port, Localhost)
		end

	new_socket: EL_STREAM_SOCKET
		require
			valid_server_port: server_port > 0
		do
			create {EL_NETWORK_STREAM_SOCKET} Result.make_server_by_port (server_port)
		end

feature {NONE} -- Implementation

	server_socket_path: FILE_PATH
		-- Unix socket path to listen on
		deferred
		end

end