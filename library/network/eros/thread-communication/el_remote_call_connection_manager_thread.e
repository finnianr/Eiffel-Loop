note
	description: "Summary description for {EL_REMOTE_CALL_CONNECTION_MANAGER_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-13 17:46:54 GMT (Wednesday 13th March 2013)"
	revision: "2"

class
	EL_REMOTE_CALL_CONNECTION_MANAGER_THREAD

inherit
	EL_CONTINUOUS_ACTION_THREAD
		rename
			loop_action as poll_for_requests
		redefine
			execute, log_name, is_visible_in_console
		end

	EL_MODULE_LOG
		undefine
			default_create, is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (
		a_port_number, request_handler_count_max: INTEGER
		a_routine_call_event_listener: EL_ROUTINE_CALL_SERVICE_EVENT_LISTENER
	)
			--
		do
			default_create
			port_number := a_port_number
			create logarithmic_polling_rates.make (5)
			(2 |..| 6).do_all (
				agent (indice: INTEGER)
					do
						logarithmic_polling_rates.extend ((2 ^ indice).rounded)
					end
			)
			logarithmic_polling_rates.start
			create client_connection_queue.make (request_handler_count_max, a_routine_call_event_listener)
		end

feature {NONE} -- Implementation

	execute
			--
		do
			log.enter ("execute")
			create connecting_socket.make_server_by_port (port_number)
			connecting_socket.listen (client_connection_queue.request_thread_count_max)
			connecting_socket.set_non_blocking
			client_connection_queue.launch

			log.put_line ("Waiting for connection ..")
			Precursor
			client_connection_queue.delegator.stop
			connecting_socket.close_socket
			log.exit
		end

	poll_for_requests
			--
		local
			polls_per_second: INTEGER
		do
			connecting_socket.accept
			if connecting_socket.is_client_connected then
				log_or_io.put_line ("Connection accepted")
				client_connection_queue.put (connecting_socket.accepted)
				log.put_line ("Waiting for connection ..")
				if not logarithmic_polling_rates.islast then
					logarithmic_polling_rates.forth
				end

			elseif not logarithmic_polling_rates.isfirst then
				logarithmic_polling_rates.back
			end
			polls_per_second := logarithmic_polling_rates.item
			sleep (1000 // polls_per_second)
		end

	client_connection_queue: EL_REMOTE_CALL_CLIENT_CONNECTION_QUEUE

	connecting_socket: EL_BYTE_COUNTING_NETWORK_STREAM_SOCKET

	port_number: INTEGER

	logarithmic_polling_rates: ARRAYED_LIST [INTEGER]

feature {NONE} -- Constants

	Log_name: STRING = "Connection manager"

	Is_visible_in_console: BOOLEAN = true

end
