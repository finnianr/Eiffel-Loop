note
	description: "Summary description for {EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_I

feature -- Basic operations

	set_stopping
			-- Shutdown the current session in the remote routine call request handler
			-- Processing instruction example:
			--		<?call {EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER}.set_stopping?>
   		deferred
   		end

feature -- Element change

	set_inbound_transmission_type (transmission_type: INTEGER)
			--
		deferred
		end

	set_outbound_transmission_type (transmission_type: INTEGER)
			--
		deferred
		end

end
