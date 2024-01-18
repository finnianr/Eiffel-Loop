note
	description: "[
		Eros server command for serializeable list of **TYPES** conforming to ${EROS_REMOTELY_ACCESSIBLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-26 6:14:53 GMT (Saturday 26th November 2022)"
	revision: "6"

deferred class
	EROS_SERVER_COMMAND [TYPES -> TUPLE create default_create end]

inherit
	EL_APPLICATION_COMMAND
		redefine
			error_check
		end

	EL_SHARED_APPLICATION

	EL_MODULE_LOG

feature {EL_COMMAND_CLIENT} -- Initialization

	make (port: INTEGER)
		require
			valid_types: valid_types
		do
			create socket.make_server_by_port (port)
			create handler.make
		end

feature -- Basic operations

	clean_up
		do
			if attached {EL_STREAM_SOCKET} socket.accepted as client then
				client.cleanup
			end
			socket.cleanup
		end

feature -- Basic operations

	error_check (a_application: EL_FALLIBLE)
		-- check for errors before execution
		local
			type_list: EL_TUPLE_TYPE_LIST [EROS_REMOTELY_ACCESSIBLE]
			error: EL_ERROR_DESCRIPTION
		do
			create type_list.make_from_tuple (create {TYPES})
			across type_list.non_conforming_list as list loop
				create error.make (Application.option_name)
				error.set_lines (Non_comforming #$ [list.item.name])
				a_application.put (error)
			end
		end

	execute
		do
			log.enter ("run")
			socket.listen (3)
			from until done loop
				lio.put_line ("Waiting for connection ..")
				socket.accept
				if attached {EL_STREAM_SOCKET} socket.accepted as client and then client.readable then
					lio.put_line ("Connection accepted")
					serve (client)
				else
					lio.put_line ("Connection not accepted")
				end
			end
			socket.cleanup
			log.exit
		end

feature -- Contract Support

	valid_types: BOOLEAN
		-- `True' if class TUPLE parameter types are valid
		local
			types: EL_TUPLE_TYPE_ARRAY
		do
			create types.make ({TYPES})
			Result := types.all_conform_to ({EROS_REMOTELY_ACCESSIBLE})
		end

feature {NONE} -- Implementation

	serve (client: EL_STREAM_SOCKET)
			--
		do
			handler.serve (client)
		end

feature {NONE} -- Internal attributes

	done: BOOLEAN

	handler: EROS_CALL_REQUEST_HANDLER

	socket: EL_NETWORK_STREAM_SOCKET
		-- connecting socket

feature {NONE} -- Constants

	Non_comforming: ZSTRING
		once
			Result := "Type %S does not conform to EROS_REMOTELY_ACCESSIBLE"
		end

end