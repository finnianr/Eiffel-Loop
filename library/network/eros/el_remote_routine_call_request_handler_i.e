note
	description: "Summary description for {EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

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