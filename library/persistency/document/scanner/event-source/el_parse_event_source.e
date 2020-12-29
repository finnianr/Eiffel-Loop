note
	description: "Parse event source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-29 13:58:05 GMT (Tuesday 29th December 2020)"
	revision: "9"

deferred class
	EL_PARSE_EVENT_SOURCE

inherit
	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		end

	EL_DOCUMENT_CLIENT

	EL_XPATH_CONSTANTS

feature {EL_FACTORY_CLIENT} -- Initialisation

	make (a_scanner: like scanner)
			--
		do
			make_default
			scanner := a_scanner

			last_node := scanner.last_node
			last_node_name := last_node.name
			last_node_text := last_node.raw_content
		end

feature -- Access

	xml_version: REAL

feature -- Status query

	has_error: BOOLEAN
		do
		end

feature -- Factory

	new_file_stream (a_file_path: EL_FILE_PATH): FILE
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

	last_node: EL_DOCUMENT_NODE

	last_node_name: STRING_32

	last_node_text: STRING_32

	attribute_list: EL_ELEMENT_ATTRIBUTE_LIST
			--
		deferred
		end

	scanner: EL_DOCUMENT_NODE_SCANNER

end