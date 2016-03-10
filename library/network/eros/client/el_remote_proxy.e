note
	description: "Summary description for {EL_REMOTE_PROXY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_REMOTE_PROXY

inherit
	EL_REMOTE_XML_OBJECT_EXCHANGER
		rename
			object_builder as Result_builder,
			make as make_remote_object_exchanger
		end

	EL_MODULE_LOG

feature -- Element change

	set_net_socket (a_net_socket: like net_socket)
			--
		do
			net_socket := a_net_socket
			make_remote_object_exchanger
			set_parse_event_generator_medium (net_socket)
			is_net_socket_set := True
		end

feature -- Status query

	has_error: BOOLEAN
			--
		do
			Result := error_code > 0
		end

	last_procedure_call_ok: BOOLEAN

	is_net_socket_set: BOOLEAN

feature -- Access

	error_code: INTEGER

feature {NONE} -- Implementation

	call (routine_name: STRING; argument_tuple: TUPLE)
			--
		require
			net_socket_set: is_net_socket_set
		local
			request: like Call_request
		do
			log.enter ("call")
			error_code := 0
			last_procedure_call_ok := false
			request := Call_request
			request.set_expression_and_serializeable_argument (Current, routine_name, argument_tuple)

			log_or_io.put_string_field ("Sending request", request.expression)
			log_or_io.put_new_line

			send_object (request, net_socket)

			Result_builder.build_from_stream (net_socket)
			result_object := Result_builder.target

			if attached {EL_EROS_ERROR_RESULT} result_object as error then
				error_code := error.id
				log_or_io.put_string_field ("ERROR", error.description)
				log_or_io.put_string (", ")
				log_or_io.put_line (error.detail)

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

	net_socket: EL_NETWORK_STREAM_SOCKET

	result_string: STRING

	result_object: EL_BUILDABLE_FROM_XML

feature {NONE} -- Constants

	Call_request: EL_EROS_REQUEST
			--
		once
			create Result.make
		end

	Result_builder: EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER
			--
		once
			create Result.make
			Result.set_plain_text_end_delimited_source
		end

end
