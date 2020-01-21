note
	description: "Eros server command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-21 16:57:46 GMT (Tuesday 21st January 2020)"
	revision: "1"

class
	EROS_SERVER_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make (port: INTEGER)
		do
			create connecting_socket.make_server_by_port (port)
			create handler.make
		end

feature -- Basic operations

	execute
		do
			log.enter ("run")
			connecting_socket.listen (3)
			from until done loop
				lio.put_line ("Waiting for connection ..")
				connecting_socket.accept
				if attached {EL_STREAM_SOCKET} connecting_socket.accepted as client and then client.readable then
					lio.put_line ("Connection accepted")
					serve (client)
				else
					lio.put_line ("Connection not accepted")
				end
			end
			connecting_socket.cleanup
			log.exit
		end

feature {NONE} -- Implementation

	serve (client: EL_STREAM_SOCKET)
			--
		do
			handler.serve (client)
		end

feature {NONE} -- Internal attributes

	connecting_socket: EL_NETWORK_STREAM_SOCKET

	handler: EROS_CALL_REQUEST_HANDLER

	done: BOOLEAN

end
