note
	description: "Remote proxy"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-19 16:30:47 GMT (Sunday 19th January 2020)"
	revision: "11"

deferred class
	EROS_REMOTE_PROXY

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

	EROS_SHARED_ERROR

feature {NONE} -- Initialization

	make (client: EROS_CLIENT_CONNECTION)
			--
		do
			make_exchanger
			make_default
			create {EROS_PROCEDURE_STATUS} result_object.make
			net_socket := client.net_socket
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

feature {NONE} -- Implementation

	call (routine_name: STRING; argument_tuple: TUPLE)
			--
		local
			request: like Call_request; l_error: EROS_ERROR_RESULT
		do
			log.enter ("call")
			error_code := 0
			last_procedure_call_ok := false
			request := Call_request
			request.set_expression_and_serializeable_argument (Current, routine_name, argument_tuple)

			lio.put_string_field ("Sending request", request.expression)
			lio.put_new_line

			send_object (request, net_socket)


			net_socket.read_string

			result_builder.build_from_string (net_socket.last_string (False))
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

			elseif attached {EROS_STRING_RESULT} result_object as string_result then
				result_string := string_result.value
				log.put_string_field ("Received string", result_string)
				log.put_new_line
			else
				log.put_string ("Received result of type: ")
				log.put_string (result_object.generator)
				log.put_new_line
			end
			log.exit
		end

	set_stopping
		do
		end

feature {NONE} -- Internal attributes

	net_socket: EL_NETWORK_STREAM_SOCKET

	result_object: EL_BUILDABLE_FROM_NODE_SCAN

	result_string: STRING

feature {NONE} -- Constants

	Call_request: EROS_REMOTE_REQUEST
			--
		once
			create Result.make
		end

end
