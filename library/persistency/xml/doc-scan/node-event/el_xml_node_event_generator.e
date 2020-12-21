note
	description: "Xml node event generator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-20 14:16:06 GMT (Sunday 20th December 2020)"
	revision: "4"

class
	EL_XML_NODE_EVENT_GENERATOR

inherit
	EL_DOCUMENT_NODE_SCANNER
		redefine
			on_start_document, on_end_document, on_start_tag, on_end_tag, on_content, on_comment
		end

create
	make_with_handler

feature -- Element change

	make_with_handler (a_handler: like handler)
		do
			handler := a_handler
			make ({EL_EXPAT_XML_PARSER})
		end

feature {NONE} -- Parsing events

	on_meta_data (version: REAL; encodeable: EL_ENCODEABLE_AS_TEXT)
			--
		do
		end

	on_start_document
			--
		do
			handler.on_start_document
		end

	on_end_document
			--
		do
			handler.on_end_document
		end

	on_start_tag
			--
		do
			handler.on_start_tag (last_node, attribute_list)
		end

	on_end_tag
			--
		do
			handler.on_end_tag (last_node)
		end

	on_content
			--
		do
			handler.on_content (last_node)
		end

	on_comment
			--
		do
			handler.on_comment (last_node)
		end

	on_processing_instruction
			--
		do
		end

feature -- Implementation

	handler: EL_DOCUMENT_PARSE_EVENT_HANDLER

end