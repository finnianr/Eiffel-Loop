note
	description: "Remote routine call request handler i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:55 GMT (Friday 10th March 2023)"
	revision: "12"

deferred class
	EROS_CALL_REQUEST_HANDLER_I

inherit
	EROS_REMOTE_CALL_CONSTANTS
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

feature {NONE} -- EROS implementation

	routines: ARRAY [TUPLE [STRING, ROUTINE]]
			-- make 'set_stopping' procedure remotely accessible by client
		do
			Result := <<
				[R_set_stopping,			agent set_stopping],
				[R_set_inbound_type, 	agent set_inbound_type],
				[R_set_outbound_type,	agent set_outbound_type]
			>>
		end

feature {NONE} -- Routine names

	R_set_stopping: STRING = "set_stopping"

	R_set_inbound_type: STRING = "set_inbound_type"

	R_set_outbound_type: STRING = "set_outbound_type"


end