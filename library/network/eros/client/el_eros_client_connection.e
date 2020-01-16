note
	description: "Eros client connection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-14 17:50:27 GMT (Tuesday 14th January 2020)"
	revision: "6"

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
			create proxy_list.make (10)
			create net_socket.make_client_by_port (port_number, host_name)
			net_socket.connect

			create remote_routine_call_request_handler.make (Current)
		end

feature -- Status setting

	set_outbound_type (type: INTEGER)
			--
		do
			remote_routine_call_request_handler.set_inbound_type (type)
			across proxy_list as proxy loop
				proxy.item.set_outbound_type (type)
			end
		end

	set_inbound_type (type: INTEGER)
			--
		do
			remote_routine_call_request_handler.set_outbound_type (type)
			across proxy_list as proxy loop
				proxy.item.set_inbound_type (type)
			end
		end

feature -- Basic operations

	close
			--
		do
			remote_routine_call_request_handler.set_stopping
			net_socket.close
		end

feature {EL_REMOTE_PROXY} -- Access

	proxy_list: ARRAYED_LIST [EL_REMOTE_PROXY]

feature {EL_REMOTE_PROXY} -- Implementation

	remote_routine_call_request_handler: EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_PROXY
		-- This is actually the object that processes remote requests.
		-- This proxy is to tell it to end the session.

	net_socket: EL_NETWORK_STREAM_SOCKET

end
