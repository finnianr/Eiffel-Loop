note
	description: "Windows implemenation of socket factory for FCGI service"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	FCGI_SOCKET_FACTORY

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
			create {EL_NETWORK_STREAM_SOCKET} Result.make_client_by_port (server_port, "localhost")
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