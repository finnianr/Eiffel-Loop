note
	description: "Summary description for {EL_EROS_CLIENT_CONNECTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_EROS_CLIENT_CONNECTION

inherit
	EL_REMOTE_CALL_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (port_number: INTEGER; host_name: STRING)
			--
		do
			create proxy_objects.make (10)
			create net_socket.make_client_by_port (port_number, host_name)
			net_socket.connect

			create remote_routine_call_request_handler
			link (<< remote_routine_call_request_handler >>)
		end

feature -- Status setting

	set_outbound_transmission_type (transmission_type: INTEGER)
			--
		do
			remote_routine_call_request_handler.set_inbound_transmission_type (transmission_type)
			proxy_objects.do_all (agent {EL_REMOTE_PROXY}.set_outbound_transmission_type (transmission_type))
		end

	set_inbound_transmission_type (transmission_type: INTEGER)
			--
		do
			remote_routine_call_request_handler.set_outbound_transmission_type (transmission_type)
			proxy_objects.do_all (agent {EL_REMOTE_PROXY}.set_inbound_transmission_type (transmission_type))
		end

feature -- Element change

	link (proxy_object_array: ARRAY [EL_REMOTE_PROXY])
			-- link proxy objects to server network connection
		do
			proxy_object_array.do_all (
				agent (remote_proxy: EL_REMOTE_PROXY)
					do
						proxy_objects.extend (remote_proxy)
						remote_proxy.set_net_socket (net_socket)
					end
			)
		end

feature -- Basic operations

	close
			--
		do
			remote_routine_call_request_handler.set_stopping
			net_socket.close
		end

feature {NONE} -- Implementation

	proxy_objects: ARRAYED_LIST [EL_REMOTE_PROXY]

	remote_routine_call_request_handler: EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_PROXY
		-- This is actually the object that processes remote requests.
		-- This proxy is to tell it to end the session.

	net_socket: EL_NETWORK_STREAM_SOCKET

end
