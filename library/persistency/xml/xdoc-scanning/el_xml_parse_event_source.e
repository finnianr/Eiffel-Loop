note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 9:03:39 GMT (Friday 8th July 2016)"
	revision: "5"

deferred class
	EL_XML_PARSE_EVENT_SOURCE

inherit
	EL_ENCODEABLE_AS_TEXT

	EL_XML_NODE_CLIENT

feature {NONE} -- Initialisation

	make (a_scanner: like scanner)
			--
		do
			scanner := a_scanner

			last_node := scanner.last_node
			last_node_name := last_node.name
			last_node_text := last_node.raw_content
			set_default_encoding
		end

feature -- Access

	xml_version: REAL

feature -- Status query

	has_error: BOOLEAN
		do
		end

feature -- Basic operations

	parse_from_stream (a_stream: IO_MEDIUM)
			-- Parse XML document from input stream.
		deferred
		end

	parse_from_string (a_string: STRING)
			-- Parse XML document from `a_string'.
		deferred
		end

	log_error (a_log: EL_LOGGABLE)
		do
		end

feature -- Element change

	set_default_encoding
		do
			set_utf_encoding (8)
		end

feature {EL_XML_DOCUMENT_SCANNER} -- Implementation: attributes

	last_node: EL_XML_NODE

	last_node_name: STRING_32

	last_node_text: STRING_32

	attribute_list: EL_XML_ATTRIBUTE_LIST
			--
		deferred
		end

	scanner: EL_XML_DOCUMENT_SCANNER

end