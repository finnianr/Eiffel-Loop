note
	description: "Windows implemenation of socket factory for FCGI service"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	FCGI_SOCKET_FACTORY

feature -- Factory

	new_client_socket: EL_STREAM_SOCKET
		require
			valid_server_port: server_port > 0
		do
			create {EL_NETWORK_STREAM_SOCKET} Result.make_client_by_port (server_port, "localhost")
		end

	new_socket: EL_STREAM_SOCKET
		require
			valid_server_port: server_port > 0
		do
			create {EL_NETWORK_STREAM_SOCKET} Result.make_server_by_port (server_port)
		end

feature {NONE} -- Implementation

	server_port: INTEGER
		-- Port server is listening on
		deferred
		end

	server_socket_path: EL_FILE_PATH
		-- Unix socket path to listen on
		deferred
		end

end
