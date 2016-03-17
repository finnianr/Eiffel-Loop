note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 13:16:18 GMT (Thursday 24th December 2015)"
	revision: "4"

class
	EL_XML_NODE_EVENT_GENERATOR

inherit
	EL_XML_DOCUMENT_SCANNER
		redefine
			on_start_document, on_end_document, on_start_tag, on_end_tag, on_content, on_comment
		end

create
	make

feature -- Element change

	make (a_handler: like handler)
		do
			handler := a_handler
			make_xml_text_source
		end

feature {NONE} -- Parsing events

	on_xml_tag_declaration (version: REAL; encodeable: EL_ENCODEABLE_AS_TEXT)
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

	handler: EL_XML_NODE_EVENT_HANDLER

end
