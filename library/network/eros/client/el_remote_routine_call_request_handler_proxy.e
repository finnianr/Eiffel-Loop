note
	description: "Summary description for {EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_PROXY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_PROXY

inherit
	EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_I

	EL_REMOTE_PROXY
		rename
			set_outbound_transmission_type as set_proxy_outbound_transmission_type,
			set_inbound_transmission_type as set_proxy_inbound_transmission_type
		export
			{NONE} all
			{ANY} set_net_socket
		end

feature -- Basic operations

	set_stopping
			-- Shutdown the current session in the remote routine call request handler
			-- Processing instruction example:
			--		<?call {EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER}.set_stopping?>
   		do
			log.enter (R_set_stopping)
			call (R_set_stopping, [])
			log.exit
   		end

feature -- Status setting

	set_inbound_transmission_type (transmission_type: INTEGER)
			--
		do
			log.enter (R_set_inbound_transmission_type)
			call (R_set_inbound_transmission_type, [transmission_type])
			log.exit
		end

	set_outbound_transmission_type (transmission_type: INTEGER)
			--
		do
			log.enter (R_set_outbound_transmission_type)
			call (R_set_outbound_transmission_type, [transmission_type])
			log.exit
		end

feature {NONE} -- Routine names

	R_set_stopping: STRING = "set_stopping"

	R_set_inbound_transmission_type: STRING = "set_inbound_transmission_type"

	R_set_outbound_transmission_type: STRING = "set_outbound_transmission_type"

end
