note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-23 17:05:56 GMT (Sunday 23rd June 2013)"
	revision: "2"

deferred class
	EL_XML_PARSE_EVENT_SOURCE

inherit
	EL_ENCODEABLE_AS_TEXT

feature {NONE} -- Initialisation

	make (a_scanner: like scanner)
			--
		do
			scanner := a_scanner

			last_node := scanner.last_node
			last_node_name := last_node.name
			last_node_text := last_node.raw_content
			encoding := Encoding_unknown
			create encoding_type.make_empty
		end

feature -- Access

	xml_version: REAL

feature -- Basic operations

	parse_from_stream (a_stream: IO_MEDIUM)
			-- Parse XML document from input stream.
		deferred
		end

	parse_from_string (a_string: STRING)
			-- Parse XML document from `a_string'.
		deferred
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
