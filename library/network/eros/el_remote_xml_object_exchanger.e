note
	description: "Summary description for {EL_XML_OBJECT_EXCHANGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-04-09 10:44:48 GMT (Saturday 9th April 2016)"
	revision: "1"

deferred class
	EL_REMOTE_XML_OBJECT_EXCHANGER

inherit
	EL_REMOTE_CALL_CONSTANTS

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make
			--
		do
			parse_event_generator := Default_parse_event_generator
			transmission_type := [Transmission_type_plaintext, Transmission_type_plaintext]
			create object_builder.make (Type_plain_text)
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
			if transmission_type.outbound = Transmission_type_binary then
				log.put_line (" as binary XML")
				parse_event_generator.send_object (object)
			else
				log.put_line (" as plaintext XML")
				object.serialize_to_stream (socket)
				socket.put_end_of_string_delimiter
			end
		end

feature -- Status report

	transmission_type: TUPLE [inbound, outbound: INTEGER]
		-- Manner in which XML is received (binary or plaintext)

feature -- Status setting

	set_inbound_transmission_type (type: INTEGER)
			--
		do
			if transmission_type.inbound /= type then
				transmission_type.inbound := type
				if type = Transmission_type_binary then
					object_builder.set_parser_type (Type_binary)
				else
					object_builder.set_parser_type (type_plain_text)
				end
			end
		end

	set_outbound_transmission_type (type: INTEGER)
			--
		do
			transmission_type.outbound := type
		end

feature {NONE} -- Internal attributes

	object_builder: EL_SMART_BUILDABLE_FROM_NODE_SCAN

	parse_event_generator: EL_XML_PARSE_EVENT_GENERATOR

feature {NONE} -- Constants

	Default_parse_event_generator: EL_XML_PARSE_EVENT_GENERATOR
		once
			create Result.make_with_output (create {EL_ZSTRING_IO_MEDIUM}.make_open_write (0))
		end

	Type_binary: TYPE [EL_PARSE_EVENT_SOURCE]
		once
			Result := {EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE}
		end

	Type_plain_text: TYPE [EL_PARSE_EVENT_SOURCE]
		once
			Result := {EL_EXPAT_XML_WITH_CTRL_Z_PARSER}
		end
end
