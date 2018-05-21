note
	description: "Server sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_SERVER_SUB_APPLICATION

inherit
	EL_SUB_APPLICATION
		rename
			on_operating_system_signal as on_ctrl_c
		redefine
			on_ctrl_c
		end

feature {NONE} -- Initiliazation

	initialize
			--
		do
			create connecting_socket.make_server_by_port (8001)
		end

feature -- Basic operations

	run
			--
		local
			exit_signal_received: BOOLEAN
		do
			log.enter ("run")
			connecting_socket.listen (3)
			from until exit_signal_received loop
				lio.put_line ("Waiting for connection ..")
				connecting_socket.accept
				if connecting_socket.is_client_connected then
					lio.put_line ("Connection accepted")
					serve (connecting_socket.accepted)
				end
			end
			connecting_socket.cleanup
			log.exit
		end

	serve (client_socket: EL_NETWORK_STREAM_SOCKET)
			--
		deferred
		end

feature {NONE} -- Implementation

	on_ctrl_c
			-- or other operating signal
		do
			log.put_new_line
			log.put_line ("Ctrl-C detected")
			log.put_line ("Disconnecting ..")
			if connecting_socket.is_client_connected then
				connecting_socket.accepted.cleanup
			end
			connecting_socket.cleanup
--			no_message_on_failure
		end

	connecting_socket: EL_BYTE_COUNTING_NETWORK_STREAM_SOCKET

end
