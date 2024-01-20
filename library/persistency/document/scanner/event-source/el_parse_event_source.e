note
	description: "Parse event source for Pyxis or XML document"
	descendants: "[
			EL_PARSE_EVENT_SOURCE*
				${EL_BINARY_ENCODED_PARSE_EVENT_SOURCE}
				${EL_DEFAULT_PARSE_EVENT_SOURCE}
				${EL_PYXIS_PARSER}
				${EL_EXPAT_XML_PARSER}
					${EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM}
					${EL_EXPAT_XML_WITH_CTRL_Z_PARSER}
					${EL_EXPAT_XHTML_PARSER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "16"

deferred class
	EL_PARSE_EVENT_SOURCE

inherit
	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		end

	EL_DOCUMENT_CLIENT

	EL_XPATH_NODE_CONSTANTS

feature {EL_FACTORY_CLIENT} -- Initialisation

	make (a_scanner: like scanner)
			--
		do
			make_default
			scanner := a_scanner
			attribute_list := a_scanner.attribute_list
			last_node := scanner.last_node
			last_node_name := last_node.raw_name
		end

feature -- Access

	xml_version: REAL

feature -- Status query

	has_error: BOOLEAN
		do
		end

feature -- Factory

	new_file_stream (a_file_path: FILE_PATH): FILE
		do
			create {PLAIN_TEXT_FILE} Result.make_with_name (a_file_path)
		ensure
			is_closed: Result.is_closed
		end

feature -- Basic operations

	parse_from_lines (a_lines: ITERABLE [READABLE_STRING_GENERAL])
		deferred
		end

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

feature {EL_DOCUMENT_NODE_SCANNER} -- Implementation: attributes

	last_node: EL_DOCUMENT_NODE_STRING

	last_node_name: EL_UTF_8_STRING

	attribute_list: EL_ELEMENT_ATTRIBUTE_LIST

	scanner: EL_DOCUMENT_NODE_SCANNER

end