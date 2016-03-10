note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_XML_NODE_VISITOR_DRIVER

inherit
	EL_XML_DOCUMENT_SCANNER
		redefine
			on_start_document, on_end_document, on_start_tag, on_end_tag, on_content, on_comment
		end

create
	make

feature -- Element change

	set_node_visitor (an_node_visitor: like node_visitor)
			-- Set `node_visitor' to `an_node_visitor'.
		do
			node_visitor := an_node_visitor
		ensure
			node_visitor_assigned: node_visitor = an_node_visitor
		end

feature {NONE} -- Parsing events

	on_xml_tag_declaration
			--
		do
		end

	on_start_document
			--
		do
			node_visitor.on_start_document
		end

	on_end_document
			--
		do
			node_visitor.on_end_document
		end

	on_start_tag
			--
		do
			node_visitor.on_start_tag (last_node, attribute_list)
		end

	on_end_tag
			--
		do
			node_visitor.on_end_tag (last_node)
		end

	on_content
			--
		do
			node_visitor.on_content (last_node)
		end

	on_comment
			--
		do
			node_visitor.on_comment (last_node)
		end

	on_processing_instruction
			--
		do
		end

feature -- Implementation

	node_visitor: EL_XML_NODE_VISITOR

end
