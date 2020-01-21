note
	description: "[
		Object to handle remote procedure call requests for the duration of a session. A session finishes when the 
		procedure `set_stopping' is called either by the server shutdown process or remotely by the client.
		
		Communication with the client is via either partial binary XML or plaintext XML. This mode is settable in either 
		direction by `set_inbound_transmission_type', set_outbound_transmission_type.
	]"
	notes: "See end of page"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-21 10:07:04 GMT (Tuesday 21st January 2020)"
	revision: "17"

class
	EROS_CALL_REQUEST_HANDLER

inherit
	EL_STOPPABLE_THREAD
		rename
			make_default as make
		redefine
			make
		end

	EROS_CALL_REQUEST_HANDLER_I
		rename
			set_outbound_type as set_pending_outbound_type
		end

	EROS_REMOTE_XML_OBJECT_EXCHANGER
		rename
			object_builder as request_builder,
			set_outbound_type as set_pending_outbound_type
		redefine
			make, request_builder
		end

	EROS_REMOTELY_ACCESSIBLE
		redefine
			make
		end

	EROS_REMOTE_CALL_ERRORS
		rename
			make_default as make
		redefine
			make
		end

	EL_THREAD_CONSTANTS

	EL_MODULE_EIFFEL

	EROS_SHARED_ERROR

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor {EL_STOPPABLE_THREAD}
			Precursor {EROS_REMOTELY_ACCESSIBLE}
			Precursor {EROS_REMOTE_XML_OBJECT_EXCHANGER}
			Precursor {EROS_REMOTE_CALL_ERRORS}

			create target_table.make (17)
			create listener
			create error_result.make
			create request_builder.make (Event_source [Type_plaintext])
			create read_listener.make
			create write_listener.make
			new_outbound_type := outbound_type
		end

feature -- Element change

	initialize
			--
		do
			set_inbound_type (Type_plaintext)
			set_pending_outbound_type (Type_plaintext)
			new_outbound_type := Type_plaintext

			target_table.wipe_out
			target_table [generator] := Current
		end

	set_listener (a_listener: like listener)
			--
		do
			listener := a_listener
		end

	set_outbound_type (type: INTEGER)
			--
		require
			valid_type: Event_source.has (type)
		do
			new_outbound_type := type
		end

feature -- Basic operations

	serve (client_socket: EL_STREAM_SOCKET)
			-- serve client for duration of session
		require
			client_socket_readable: client_socket.readable
		do
			log.enter ("serve")
			client_socket.set_latin_encoding (1)
			initialize

			from set_active until is_stopped loop
				reset_errors
				read_listener.set_socket (client_socket)
				write_listener.set_socket (client_socket)

				client_socket.read_string
				request_builder.build_from_string (client_socket.last_string (False))
				listener.received_bytes (read_listener.bytes_read_count)

				if request_builder.has_error then
					set_error (Error.syntax_error_in_routine_call, request_builder.source_text.as_string_8)
				end
				if not has_error then
					call_class_routine
				end
				if has_error then
					error_result.set_id (error_code)
					error_result.set_detail (error_detail)
					result_object := error_result
					listener.routine_failed
				end

				send_object (result_object, client_socket)

				-- if outbound_transmission_type has changed as the result of remote call
				if new_outbound_type /= outbound_type then
					set_pending_outbound_type (new_outbound_type)
				end

				listener.sent_bytes (write_listener.bytes_sent_count)

				if is_stopping or not client_socket.readable then
					log.put_line ("stopping session")
					set_stopped
				end
			end
			client_socket.close
			log.exit
		end

feature {NONE} -- Implementation

	call_class_routine
			-- call routine and set result object
		local
			target: EROS_REMOTELY_ACCESSIBLE
		do
			log.enter ("call_routine")
			if target_table.has_key (request_builder.class_name) then
				target := target_table.found_item
			elseif Factory.valid_name (request_builder.class_name)
				and then attached new_target (request_builder.class_name) as new
			then
				target := new
				target_table.extend (new, request_builder.class_name)
			else
				set_error (Error.invalid_type, request_builder.class_name)
			end
			if not has_error then
				target.set_arguments (request_builder)
				if not target.has_error and then target.is_routine_set then
					log.put_line (request_builder.source_text.as_string_8)
					log.put_new_line
					target.call_routine
					listener.called_routine (target.function_requested)
					result_object := target.result_object
				else
					set_error (target.error_code, target.error_detail)
				end
			end
			log.exit
		end

	new_target (class_name: STRING): detachable EROS_REMOTELY_ACCESSIBLE
		do
			if attached {like new_target} Factory.new_item_from_name (class_name) as new then
				new.make
				Result := new
			end
		end

feature {NONE} -- EROS implementation

	Factory: EL_OBJECT_FACTORY [EROS_REMOTELY_ACCESSIBLE]
			--
		once
			create Result
		end

feature {NONE} -- Internal attributes

	read_listener: EL_READ_BYTE_COUNTING_LISTENER

	write_listener: EL_WRITTEN_BYTE_COUNTING_LISTENER

	error_result: EROS_ERROR_RESULT

	listener: EROS_ROUTINE_CALL_SERVICE_EVENT_LISTENER

	new_outbound_type: INTEGER

	target_table: HASH_TABLE [EROS_REMOTELY_ACCESSIBLE, STRING]
		-- objects available for duration of client sesssion

	request_builder: EROS_CALL_REQUEST_BUILDABLE_FROM_NODE_SCAN;

note
	notes: "[
		**AN EXAMPLE OF AN EROS XML PROCEDURE CALL**

		Suppose for example we have an audio player application that is able to play SMIL play lists. The audio player
		has a class `[$source SMIL_PRESENTATION]'
		that knows how to build itself from a SMIL document. The application has a remotely
		accessible class `AUDIO_DEVICE' with a procedure play_presentation taking an argument of type `SMIL_PRESENTATION'. In
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
		The first instruction `<?create {SMIL_PRESENTATION}?>' is self-explanatory, creating an instance of `SMIL_PRESENTATION' to which
		is added the document data as it is incrementally parsed. By the end of the document, the `SMIL_PRESENTATION' instance contains
		a representation of the audio clip data. The call instruction on the last line invokes the procedure play_presentation passing
		the instance of `SMIL_PRESENTATION' as an argument. `AUDIO_DEVICE' is a place holder for an instance of `AUDIO_DEVICE' created at
		the start of a client session.

		The syntax of the call residing in the processing instruction is reminiscent of the syntax for Eiffel agents.
		`SMIL_PRESENTATION' serves as a place-holder for the object created with the create instruction.
	]"

end
