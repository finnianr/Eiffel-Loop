note
	description: "Eros server command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 13:59:15 GMT (Thursday 13th January 2022)"
	revision: "3"

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

feature -- Access

	description: READABLE_STRING_GENERAL
		do
			Result := default_description
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

	done: BOOLEAN

	handler: EROS_CALL_REQUEST_HANDLER

	socket: EL_NETWORK_STREAM_SOCKET
		-- connecting socket

end