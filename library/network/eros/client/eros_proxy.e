note
	description: "Base class for objects that function as network-client proxies for objects hosted on server"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "15"

deferred class
	EROS_PROXY

inherit
	EROS_REMOTE_XML_OBJECT_EXCHANGER
		rename
			make as make_exchanger,
			object_builder as result_builder
		undefine
			routines
		end

	EROS_OBJECT
		export
			{EROS_REMOTE_REQUEST} routine_table
		end

	EL_MODULE_LOG
		export
			{EROS_RESULT} log
		end

	EROS_SHARED_ERROR

feature {NONE} -- Initialization

	make (client: EROS_CLIENT_CONNECTION)
			--
		do
			make_exchanger
			make_default
			create {EROS_PROCEDURE_STATUS} result_object.make
			socket := client.socket
			client.proxy_list.extend (Current)
		end

feature -- Status query

	has_error: BOOLEAN
			--
		do
			Result := error_code > 0
		end

	last_procedure_call_ok: BOOLEAN

feature -- Access

	error_code: NATURAL_8

feature {EROS_RESULT} -- Implementation

	boolean_call (routine_name: STRING; argument_tuple: TUPLE): BOOLEAN
		do
			Result := create {EROS_RESULT [BOOLEAN]}.make_call (Current, routine_name, argument_tuple)
		end

	call (routine_name: STRING; argument_tuple: TUPLE)
			--
		local
			request: like Call_request; l_error: EROS_ERROR_RESULT
		do
			log.enter ("call")
			error_code := 0
			last_procedure_call_ok := false
			request := Call_request
			request.set_processing_instruction (Current, routine_name, argument_tuple)

			lio.put_labeled_string ("Sending request", request.expression)
			lio.put_new_line

			send_object (request, socket)

			socket.read_string

			result_builder.build_from_string (socket.last_string (False))
			if result_builder.has_item and then attached result_builder.item as l_object then
				result_object := l_object
			else
				create l_error.make
				l_error.set_id (Error.invalid_result)
				l_error.set_detail ("No result created")
				result_object := l_error
			end
			if attached {EROS_ERROR_RESULT} result_object as error_result then
				error_code := Error.value (error_result.id)
				lio.put_labeled_substitution ("ERROR", "%S, %S", [error_result.description, error_result.detail])
				lio.put_new_line

			elseif attached {EROS_PROCEDURE_STATUS} result_object as procedure_status then
				log.put_line ("Received acknowledgement")
				last_procedure_call_ok := true
			end
			log.exit
		end

	integer_call, integer_32_call (routine_name: STRING; argument_tuple: TUPLE): INTEGER
		do
			Result := create {EROS_RESULT [INTEGER]}.make_call (Current, routine_name, argument_tuple)
		end

	set_stopping
		do
		end

feature {EROS_RESULT} -- Internal attributes

	socket: EL_NETWORK_STREAM_SOCKET

	result_object: EL_BUILDABLE_FROM_NODE_SCAN

feature {NONE} -- Constants

	Call_request: EROS_REMOTE_REQUEST
			--
		once
			create Result.make
		end

end