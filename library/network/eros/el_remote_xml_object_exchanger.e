note
	description: "Remote xml object exchanger"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-09 18:37:55 GMT (Thursday 9th January 2020)"
	revision: "5"

deferred class
	EL_REMOTE_XML_OBJECT_EXCHANGER

inherit
	EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER_I

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make
			--
		do
			parse_event_generator := Default_parse_event_generator
			inbound_type := Type_plaintext; outbound_type := Type_plaintext
			create object_builder.make (Event_source [Type_plaintext])
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
			log.put_labeled_substitution (
				once "Sending", once "%S as %S XML", [object.generator, Event_source_name [outbound_type]]
			)
			log.put_new_line
			if outbound_type = Type_binary then
				parse_event_generator.send_object (object)
			else
				object.serialize_to_stream (socket)
				socket.put_end_of_string_delimiter
			end
		end

feature -- Status report

	inbound_type: INTEGER
		-- type of inbound transmission

	outbound_type: INTEGER
		-- type of outbound transmission

feature -- Status setting

	set_inbound_type (type: INTEGER)
			--
		do
			inbound_type := type
			object_builder.set_parser_type (Event_source [type])
		end

	set_outbound_type (type: INTEGER)
			--
		do
			outbound_type := type
		end

feature {NONE} -- Internal attributes

	object_builder: EL_SMART_BUILDABLE_FROM_NODE_SCAN

	parse_event_generator: EL_XML_PARSE_EVENT_GENERATOR

feature {NONE} -- Constants

	Default_parse_event_generator: EL_XML_PARSE_EVENT_GENERATOR
		once
			create Result.make_with_output (create {EL_ZSTRING_IO_MEDIUM}.make_open_write (0))
		end

end
