note
	description: "Remote routine call request handler i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-09 18:37:55 GMT (Thursday 9th January 2020)"
	revision: "6"

deferred class
	EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_I

inherit
	EL_REMOTE_CALL_CONSTANTS
		export
			{ANY} Event_source
		end

feature -- Basic operations

	set_stopping
			-- Shutdown the current session in the remote routine call request handler
			-- Processing instruction example:
			--		<?call {EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER}.set_stopping?>
   		deferred
   		end

feature -- Element change

	set_inbound_type (type: INTEGER)
			-- set inbound transmission type
		require
			valid_type: Event_source.has (type)
		deferred
		end

	set_outbound_type (type: INTEGER)
			-- set outbound transmission type
		require
			valid_type: Event_source.has (type)
		deferred
		end

end
