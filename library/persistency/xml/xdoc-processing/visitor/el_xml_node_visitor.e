note
	description: "Summary description for {EL_XML_DOCUMENT_SCANNER_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 10:40:02 GMT (Friday 8th July 2016)"
	revision: "5"

deferred class
	EL_XML_NODE_VISITOR

inherit
	EL_MODULE_LIO

	EL_XML_NODE_CLIENT

feature {NONE}  -- Initialisation

	make
			--
		do
			create last_node
			last_node_name := last_node.name
			last_node_text := last_node.raw_content
			set_parse_event_source (new_parse_event_source (Current))
		end

feature -- Access

	encoding: INTEGER
			--
		do
			Result := parse_event_source.encoding
		end

	encoding_type: STRING
			--
		do
			Result := parse_event_source.encoding_type
		end

	encoding_name: STRING
			--
		do
			Result := parse_event_source.encoding_name
		end

	xml_version: REAL
			--
		do
			Result := parse_event_source.xml_version
		end

feature -- Basic operations

	do_from_string (a_string: STRING)
			--
		do
			parse_event_source.parse_from_string (a_string)
		end

	do_from_stream (a_stream: IO_MEDIUM)
			--
		do
			parse_event_source.parse_from_stream (a_stream)
			if parse_event_source.has_error then
				parse_event_source.log_error (lio)
			end
		end

feature -- Status report

	is_plain_text: BOOLEAN
			--
		do
			Result := parse_event_source.is_plain_text
		end

feature {EL_XML_PARSE_EVENT_SOURCE} -- Parsing events

	on_xml_tag_declaration (version: REAL; encodeable: EL_ENCODEABLE_AS_TEXT)
			--
		deferred
		end

	on_start_document
			--
		deferred
		end

	on_end_document
			--
		deferred
		end

	on_start_tag
			--
		deferred
		end

	on_end_tag
			--
		deferred
		end

	on_content
			--
		deferred
		end

	on_comment
			--
		deferred
		end

	on_processing_instruction
			--
		deferred
		end

feature {NONE} -- Implementation

	set_parse_event_source (a_parse_event_source: like parse_event_source)
			--
		do
			parse_event_source := a_parse_event_source
			attribute_list := parse_event_source.attribute_list
		end

	new_parse_event_source (scanner: like Current): EL_XML_PARSE_EVENT_SOURCE_2
		deferred
		end

feature {EL_XML_PARSE_EVENT_SOURCE_2} -- Implementation: attributes

	last_node: EL_XML_NODE

	last_node_name: STRING_32

	last_node_text: STRING_32

	attribute_list: EL_XML_ATTRIBUTE_LIST

	parse_event_source: like new_parse_event_source

end
