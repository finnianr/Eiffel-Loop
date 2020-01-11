note
	description: "Remote proxy"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-10 22:00:32 GMT (Friday 10th January 2020)"
	revision: "7"

class
	EL_REMOTE_PROXY

inherit
	EL_REMOTE_XML_OBJECT_EXCHANGER
		rename
			make as make_exchanger,
			object_builder as result_builder
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (client: EL_EROS_CLIENT_CONNECTION)
			--
		do
			make_exchanger
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

	error_code: INTEGER

feature {NONE} -- Implementation

	call (routine_name: STRING; argument_tuple: TUPLE)
			--
		local
			request: like Call_request
		do
			log.enter ("call")
			error_code := 0
			last_procedure_call_ok := false
			request := Call_request
			request.set_expression_and_serializeable_argument (Current, routine_name, argument_tuple)

			lio.put_string_field ("Sending request", request.expression)
			lio.put_new_line

			send_object (request, net_socket)

			result_builder.build_from_stream (net_socket)
			result_object := result_builder.item

			if attached {EL_EROS_ERROR_RESULT} result_object as error then
				error_code := error.id
				lio.put_string_field ("ERROR", error.description)
				lio.put_string (", ")
				lio.put_line (error.detail)

			elseif attached {EL_EROS_PROCEDURE_STATUS} result_object as procedure_status then
				log.put_line ("Received acknowledgement")
				last_procedure_call_ok := true

			elseif attached {EL_EROS_STRING_RESULT} result_object as string_result then
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

	Call_request: EL_EROS_REQUEST
			--
		once
			create Result.make
		end

end
