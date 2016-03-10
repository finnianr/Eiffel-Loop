note
	description: "Summary description for {EL_XML_DOCUMENT_SCANNER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-23 17:09:19 GMT (Sunday 23rd June 2013)"
	revision: "2"

deferred class
	EL_XML_DOCUMENT_SCANNER

feature {NONE}  -- Initialisation

	make
			--
		do
			make_last_node
			set_plain_text_source
		end

	make_pyxis_source
			--
		do
			make_last_node
			set_pyxis_text_source
		end

	make_delimited_source
			--
		do
			make_last_node
			set_plain_text_end_delimited_source
		end

	make_binary_source
			--
		do
			make_last_node
			set_binary_node_source
		end

	make_last_node
			--
		do
			create last_node
			last_node_name := last_node.name
			last_node_text := last_node.raw_content
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

feature -- Status report

	is_binary_event_source: BOOLEAN
			--
		do
			if attached {EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE} parse_event_source as source then
				Result := True
			end
		end

	is_plain_text_event_source: BOOLEAN
			--
		do
			if attached {EL_EXPAT_XML_PARSER} parse_event_source as source then
				Result := not source.is_stream_delimited
			end
		end

	is_pyxis_text_event_source: BOOLEAN
			--
		do
			Result := attached {EL_PYXIS_PARSER} parse_event_source
		end

	is_plain_text_end_delimited_event_source: BOOLEAN
			--
		do
			if attached {EL_EXPAT_XML_PARSER} parse_event_source as source then
				Result := source.is_stream_delimited
			end
		end

feature -- Element change

	set_binary_node_source
			--
		do
			if not attached {EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE} parse_event_source as binary then
				set_parse_event_source (create {EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE}.make (Current))
			end
		end

	set_plain_text_source
			--
		do
			if not attached {EL_EXPAT_XML_PARSER} parse_event_source as expat then
				set_parse_event_source (create {EL_EXPAT_XML_PARSER}.make (Current))
			end
		end

	set_pyxis_text_source
			--
		do
			if not attached {EL_PYXIS_PARSER} parse_event_source as pyxis then
				set_parse_event_source (create {EL_PYXIS_PARSER}.make (Current))
			end
		end

	set_plain_text_end_delimited_source
			--
		do
			set_plain_text_source
			if attached {EL_EXPAT_XML_PARSER} parse_event_source as parser then
				if not parser.is_stream_delimited then
					parser.set_stream_delimited (True)
				end
			end
		end

feature -- Basic operations

	scan (a_string: STRING)
			--
		do
			parse_event_source.parse_from_string (a_string)
		end

	scan_from_stream (a_stream: IO_MEDIUM)
			--
		do
			parse_event_source.parse_from_stream (a_stream)
		end

feature {EL_XML_PARSE_EVENT_SOURCE} -- Parsing events

	on_xml_tag_declaration
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

feature {EL_XML_PARSE_EVENT_SOURCE} -- Implementation: attributes

	last_node: EL_XML_NODE

	last_node_name: STRING_32

	last_node_text: STRING_32

	attribute_list: EL_XML_ATTRIBUTE_LIST

	parse_event_source: EL_XML_PARSE_EVENT_SOURCE

end
