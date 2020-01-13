note
	description: "Remote routine call request handler proxy"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 8:54:02 GMT (Monday 13th January 2020)"
	revision: "6"

class
	EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_PROXY

inherit
	EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_I

	EL_REMOTE_PROXY
		export
			{NONE} all
		undefine
			set_stopping
		redefine
			set_inbound_type, set_outbound_type
		end

create
	make

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

	set_inbound_type (type: INTEGER)
			--
		do
			log.enter (R_set_inbound_type)
			call (R_set_inbound_type, [type])
			log.exit
		end

	set_outbound_type (type: INTEGER)
			--
		do
			log.enter (R_set_outbound_type)
			call (R_set_outbound_type, [type])
			log.exit
		end

end
