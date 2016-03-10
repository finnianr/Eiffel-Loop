note
	description: "Summary description for {EL_XML_OBJECT_EXCHANGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 21:03:16 GMT (Monday 22nd July 2013)"
	revision: "2"

deferred class
	EL_REMOTE_XML_OBJECT_EXCHANGER

inherit
	EL_REMOTE_CALL_CONSTANTS

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make
			--
		do
			create parse_event_generator.make_with_output (create {EL_TEXT_IO_MEDIUM}.make_open_write (0))
			inbound_transmission_type := Transmission_type_plaintext
			outbound_transmission_type := Transmission_type_plaintext
		end

feature -- Element change

	set_parse_event_generator_medium (socket: EL_STREAM_SOCKET)
			--
		do
			create parse_event_generator.make_with_output (socket)
		end

feature -- Basic operations

	send_object (object: EVOLICITY_SERIALIZEABLE_AS_XML; socket: EL_STREAM_SOCKET)
			--
		do
			log.put_string ("Sending ")
			log.put_string (object.generator)
			if outbound_transmission_type = Transmission_type_binary then
				log.put_line (" as binary XML")
				parse_event_generator.send_object (object)
			else
				log.put_line (" as plaintext XML")
				object.serialize_to_stream (socket)
				socket.put_end_of_string_delimiter
			end
		end

feature -- Status report

	inbound_transmission_type: INTEGER
		-- Manner in which XML is received (binary or plaintext)

	outbound_transmission_type: INTEGER
		-- Manner in which XML is sent (binary or plaintext)

feature -- Status setting

	set_inbound_transmission_type (transmission_type: INTEGER)
			--
		do
			if inbound_transmission_type /= transmission_type then
				inbound_transmission_type := transmission_type
				if inbound_transmission_type = Transmission_type_binary then
					object_builder.set_binary_node_source
				else
					object_builder.set_plain_text_end_delimited_source
				end
			end
		end

	set_outbound_transmission_type (transmission_type: INTEGER)
			--
		do
			outbound_transmission_type := transmission_type
		end

feature {NONE} -- Implementation

	object_builder: EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER
			--
		deferred
		end

	parse_event_generator: EL_XML_PARSE_EVENT_GENERATOR

end