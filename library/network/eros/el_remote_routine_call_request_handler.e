note
	description: "[
		Object to handle remote procedure call requests for the duration of a session. A session finishes when the 
		procedure 'set_stopping' is called either by the server shutdown process or remotely by the client.
		
		Communication with the client is via either partial binary XML or plaintext XML. This mode is settable in either 
		direction by set_inbound_transmission_type, set_outbound_transmission_type.
		
		AN EXAMPLE OF AN EROS XML PROCEDURE CALL:

		Suppose for example we have an audio player application that is able to play SMIL play lists. The audio player 
		has a class SMIL_PRESENTATION that knows how to build itself from a SMIL document. The application has a remotely 
		accessible class AUDIO_DEVICE with a procedure play_presentation taking an argument of type SMIL_PRESENTATION. In 
		this example a SMIL document defines some clips to be played sequentially from an audio file. An EXP call message 
		to remotely call the play_presentation procedure is created by inserting the processing instructions
		into the SMIL document.

		<?xml version="1.0" encoding="ISO-8859-1"?>
		<?create {SMIL_PRESENTATION}?>
		<smil xmlns="http://www.w3.org/2001/SMIL20/Language">
			<head>
				<meta name="base" content="file:///home/john/audio-assets/linguistic/study/"/>
				<meta name="author" content="Dr. John Smith"/>
				<meta name="title" content="Linguistic analysis"/>
			</head>
			<body>
				<seq id="seq_1" title="Extracts of conversation between Bill and Susan">
				    <audio id="audio_1" title="Greeting" src="Bill-and-Susan.mp3" clipBegin="5.5s" clipEnd="18.0s"/>
				    <audio id="audio_2" title="Interjection" src="Bill-and-Susan.mp3" clipBegin="25.5s" clipEnd="30.0s"/>
				    <audio id="audio_3" title="Disagreement" src="Bill-and-Susan.mp3" clipBegin="55.0s" clipEnd="67.0s"/>
				</seq>
			</body>
		</smil>
		<?call {AUDIO_DEVICE}.play_presentation ({SMIL_PRESENTATION})?>

		The order of the processing instructions is significant as they are executed during an incremental parse of the document. 
		The first instruction <?create {SMIL_PRESENTATION}?> is self-explanatory, creating an instance of SMIL_PRESENTATION to which
		is added the document data as it is incrementally parsed. By the end of the document, the SMIL_PRESENTATION instance contains
		a representation of the audio clip data. The call instruction on the last line invokes the procedure play_presentation passing
		the instance of SMIL_PRESENTATION as an argument. {AUDIO_DEVICE} is a place holder for an instance of AUDIO_DEVICE created at
		the start of a client session.

		The syntax of the call residing in the processing instruction is reminiscent of the syntax for Eiffel agents.
		{SMIL_PRESENTATION} serves as a place-holder for the object created with the create instruction.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER

inherit
	EL_STOPPABLE_THREAD

	EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_I
		undefine
			default_create
		end

	EL_REMOTE_XML_OBJECT_EXCHANGER
		rename
			object_builder as Request_builder,
			make as make_remote_object_exchanger,
			set_outbound_transmission_type as set_pending_outbound_transmission_type
		undefine
			default_create
		end

	EL_REMOTE_CALL_ERRORS
		undefine
			default_create
		end

	EL_THREAD_CONSTANTS
		undefine
			default_create
		end

	EL_REMOTELY_ACCESSIBLE
		rename
			functions as No_functions
		undefine
			default_create
		redefine
			make
		end

	EL_MODULE_TYPING
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			default_create
			Precursor
			make_remote_object_exchanger

			create target_table.make (17)
			create listener
			create error_result.make
			new_outbound_transmission_type := outbound_transmission_type
		end

feature -- Element change

	set_listener (a_listener: like listener)
			--
		do
			listener := a_listener
		end

	set_outbound_transmission_type (transmission_type: INTEGER)
			--
		do
			new_outbound_transmission_type := transmission_type
		end

	initialize (client_socket: EL_BYTE_COUNTING_NETWORK_STREAM_SOCKET)
			--
		do
			set_parse_event_generator_medium (client_socket)

			set_inbound_transmission_type (Transmission_type_plaintext)
			set_pending_outbound_transmission_type (Transmission_type_plaintext)
			new_outbound_transmission_type := Transmission_type_plaintext

			target_table.wipe_out
			target_table [generator] := Current
		end

feature -- Basic operations

	serve (client_socket: EL_BYTE_COUNTING_NETWORK_STREAM_SOCKET)
			-- serve client for duration of session
		do
			log.enter ("serve")
			initialize (client_socket)

			from set_active until is_stopped loop
				set_error (0)
				set_error_detail ("")
				client_socket.reset_counts

				if not client_socket.is_readable then
					set_stopping
				else
					Request_builder.build_from_stream (client_socket)
					listener.received_bytes (client_socket.bytes_received)
				end

				if Request_builder.has_error then
					set_error (Error_syntax_error_in_routine_call)
					set_error_detail (Request_builder.call_request_source_text.as_string_8)
				end

				if not has_error then
					call_routine
				end
				if has_error then
					error_result.set_id (error_code)
					error_result.set_detail (error_detail)
					result_object := error_result
					listener.routine_failed
				end

				send_object (result_object, client_socket)

				-- if outbound_transmission_type has changed as the result of remote call
				if new_outbound_transmission_type /= outbound_transmission_type then
					set_pending_outbound_transmission_type (new_outbound_transmission_type)
				end

				listener.sent_bytes (client_socket.bytes_sent)

				if is_stopping then
					log.put_line ("stopping session")
					set_stopped
				end
			end
			client_socket.close
			log.exit
		end

feature {NONE} -- Implementation

	call_routine
			-- call routine and set result object
		local
			target: EL_REMOTELY_ACCESSIBLE
		do
			log.enter ("call_routine")
			target_table.search (Request_builder.class_name)
			if target_table.found then
				target := target_table.found_item
			else
				if attached {EL_REMOTELY_ACCESSIBLE}
					Factory.instance_from_class_name (
						Request_builder.class_name, agent {EL_REMOTELY_ACCESSIBLE}.do_nothing
					) as new_target
				then
					target := new_target
					target_table.extend (target, Request_builder.class_name)
				else
					set_error (Error_class_name_not_found)
					set_error_detail (Request_builder.class_name)
				end
			end

			if not has_error then
				target.set_routine_with_arguments (
					Request_builder.routine_name, Request_builder.call_argument, Request_builder.argument_list
				)
				if not target.has_error then
					log.put_line (Request_builder.call_request_source_text.as_string_8)
					log.put_new_line
					if target.is_procedure_set then
						target.call_procedure
						listener.called_procedure
					else
						target.call_function
						listener.called_function
					end
					result_object := target.result_object
				else
					set_error (target.error_code)
					set_error_detail (target.error_detail)
				end
			end
			log.exit
		end

	target_table: HASH_TABLE [EL_REMOTELY_ACCESSIBLE, STRING]
		-- objects available for duration of client sesssion

	listener: EL_ROUTINE_CALL_SERVICE_EVENT_LISTENER

	error_result: EL_EROS_ERROR_RESULT

	new_outbound_transmission_type: INTEGER

feature {NONE} -- EROS implementation

	Factory: EL_OBJECT_FACTORY [EL_REMOTELY_ACCESSIBLE]
			--
		once
			create Result
		end

	procedures: ARRAY [like procedure_mapping]
			-- make 'set_stopping' procedure remotely accessible by client
		do
			Result := <<
				["set_stopping", agent set_stopping],
				["set_inbound_transmission_type", agent set_inbound_transmission_type],
				["set_outbound_transmission_type", agent set_outbound_transmission_type]
			>>
		end

feature {NONE} -- Constants

	Request_builder: EL_ROUTINE_CALL_REQUEST_XML_TO_EIFFEL_BUILDER
			--
		once
			create Result.make
			Result.set_plain_text_end_delimited_source
		end

end
