note
	description: "Eros server command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-22 10:50:14 GMT (Wednesday 22nd January 2020)"
	revision: "2"

class
	EROS_SERVER_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make (port: INTEGER)
		do
			create socket.make_server_by_port (port)
			create handler.make
		end

feature -- Basic operations

	execute
		do
			log.enter ("run")
			socket.listen (3)
			from until done loop
				lio.put_line ("Waiting for connection ..")
				socket.accept
				if attached {EL_STREAM_SOCKET} socket.accepted as client and then client.readable then
					lio.put_line ("Connection accepted")
					serve (client)
				else
					lio.put_line ("Connection not accepted")
				end
			end
			socket.cleanup
			log.exit
		end

feature {NONE} -- Implementation

	serve (client: EL_STREAM_SOCKET)
			--
		do
			handler.serve (client)
		end

feature {NONE} -- Internal attributes

	socket: EL_NETWORK_STREAM_SOCKET
		-- connecting socket

	handler: EROS_CALL_REQUEST_HANDLER

	done: BOOLEAN

end
