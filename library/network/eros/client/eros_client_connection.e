note
	description: "Eros client connection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EROS_CLIENT_CONNECTION

inherit
	EROS_REMOTE_CALL_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (port_number: INTEGER; host_name: STRING)
			--
		do
			create proxy_list.make (10)
			create socket.make_client_by_port (port_number, host_name)
			socket.connect

			create handler.make (Current)
		end

feature -- Status setting

	set_outbound_type (type: INTEGER)
			--
		do
			handler.set_inbound_type (type)
			across proxy_list as proxy loop
				proxy.item.set_outbound_type (type)
			end
		end

	set_inbound_type (type: INTEGER)
			--
		do
			handler.set_outbound_type (type)
			across proxy_list as proxy loop
				proxy.item.set_inbound_type (type)
			end
		end

feature -- Basic operations

	close
			--
		do
			handler.set_stopping
			socket.cleanup
		end

feature {EROS_PROXY} -- Access

	proxy_list: ARRAYED_LIST [EROS_PROXY]

feature {EROS_PROXY} -- Implementation

	handler: EROS_CALL_REQUEST_HANDLER_PROXY
		-- This is actually the object that processes remote requests.
		-- This proxy is to tell it to end the session.

	socket: EL_NETWORK_STREAM_SOCKET

end