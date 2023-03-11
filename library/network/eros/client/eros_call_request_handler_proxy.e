note
	description: "Remote routine call request handler proxy"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:55 GMT (Friday 10th March 2023)"
	revision: "11"

class
	EROS_CALL_REQUEST_HANDLER_PROXY

inherit
	EROS_CALL_REQUEST_HANDLER_I

	EROS_PROXY
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