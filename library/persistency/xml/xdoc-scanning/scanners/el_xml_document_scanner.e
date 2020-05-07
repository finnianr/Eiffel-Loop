note
	description: "[
		Scans sequentially the XML node visiting events originating from `event_source'.
		
		The event source can be any of the following types:
		
		**1.** [$source EL_EXPAT_XML_PARSER]: Expat XML parser
		
		**2.** [$source EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM]: Expat XML parser of XML serializeable objects conforming to
		[$source EVOLICITY_SERIALIZEABLE_AS_XML].
		
		**3.** [$source EL_EXPAT_XML_WITH_CTRL_Z_PARSER]: Expat XML parser with input stream end delimited
		by Ctrl-Z character. Useful for parsing network streams.
		
		**4.** [$source EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE]: a binary encoded XML event source.
		
		**5.** [$source EL_PYXIS_PARSER]: event from a Pyxis format parser. Pyxis is a direct analog of XML that is
		easier to read and edit thus making it more suitable for configuration files.

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-07 9:20:01 GMT (Thursday 7th May 2020)"
	revision: "11"

deferred class
	EL_XML_DOCUMENT_SCANNER

inherit
	EL_MODULE_LIO

	EL_XML_NODE_CLIENT

	EL_FACTORY_CLIENT

feature {NONE}  -- Initialisation

	make (type: TYPE [EL_PARSE_EVENT_SOURCE])
		do
			make_default
			set_parser_type (type)
		end

	make_default
			--
		do
			create last_node.make
			event_source := default_event_source
			last_node_name := last_node.name
			last_node_text := last_node.raw_content
		end

feature -- Access

	encoding: NATURAL
		-- bitwise OR of encoding type and encoding id
		do
			Result := event_source.encoding
		end

	encoding_name: STRING
			--
		do
			Result := event_source.encoding_name
		end

	xml_version: REAL
			--
		do
			Result := event_source.xml_version
		end

feature -- Element change

	set_parser_type (type: TYPE [EL_PARSE_EVENT_SOURCE])
			--
		do
			if {ISE_RUNTIME}.dynamic_type (event_source) /= type.type_id
				and then attached {like event_source} Factory.new_item_from_type (type) as l_source
			then
				l_source.make (Current)
				event_source := l_source
			end
		end

feature -- Basic operations

	scan (a_string: STRING)
			--
		do
			event_source.parse_from_string (a_string)
		end

	scan_from_stream (a_stream: IO_MEDIUM)
			--
		do
			event_source.parse_from_stream (a_stream)
			if event_source.has_error then
				event_source.log_error (lio)
			end
		end

	scan_from_lines (a_lines: ITERABLE [READABLE_STRING_GENERAL])
			--
		do
			if attached {EL_PYXIS_PARSER} event_source as pyxis_source then
				pyxis_source.parse_from_lines (new_string_list (a_lines))
				if pyxis_source.has_error then
					pyxis_source.log_error (lio)
				end
			else
				scan (new_string_list (a_lines).joined_lines.to_utf_8)
			end
		end

feature {EL_PARSE_EVENT_SOURCE} -- Parsing events

	on_comment
			--
		deferred
		end

	on_content
			--
		deferred
		end

	on_end_document
			--
		deferred
		end

	on_end_tag
			--
		deferred
		end

	on_processing_instruction
			--
		deferred
		end

	on_start_document
			--
		deferred
		end

	on_start_tag
			--
		deferred
		end

	on_xml_tag_declaration (version: REAL; encodeable: EL_ENCODEABLE_AS_TEXT)
			--
		deferred
		end

feature {EL_PARSE_EVENT_SOURCE, EL_CREATEABLE_FROM_NODE_SCAN} -- Access

	event_source: EL_PARSE_EVENT_SOURCE

	last_node: EL_XML_NODE

feature {NONE} -- Implementation

	default_event_source: EL_PARSE_EVENT_SOURCE
		do
			create {EL_DEFAULT_PARSE_EVENT_SOURCE} Result.make (Current)
		end

	new_string_list (lines: ITERABLE [READABLE_STRING_GENERAL]): EL_ZSTRING_LIST
		do
			create Result.make_from_general (lines)
		end

feature {NONE} -- Implementation: attributes

	attribute_list: EL_XML_ATTRIBUTE_LIST
		do
			Result := event_source.attribute_list
		end

	last_node_name: STRING_32

	last_node_text: STRING_32

feature {NONE} -- Constants

	Factory: EL_OBJECT_FACTORY [EL_PARSE_EVENT_SOURCE]
		once
			create Result
		end
end
