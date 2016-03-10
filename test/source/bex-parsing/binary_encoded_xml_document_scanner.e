note
	description: "Summary description for {COMPRESSED_XML_DOCUMENT_SCANNER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:21 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	BINARY_ENCODED_XML_DOCUMENT_SCANNER

inherit
	EL_XML_DOCUMENT_SCANNER
		redefine
			make, 
			on_xml_tag_declaration, on_start_document, on_end_document,
			on_start_tag, on_end_tag, on_content, on_comment, on_processing_instruction
		end

	EL_MODULE_LOG

create
	make

feature {NONE}  -- Initialisation

	make
			--
		do
			Precursor
			create name_stack.make (7)
		end

feature {NONE} -- Parsing events

	on_xml_tag_declaration
			--
		do
			log.enter ("on_xml_tag_declaration")
			log.exit
		end

	on_start_document
			--
		do
			log.enter ("on_start_document")
			log.exit
		end

	on_end_document
			--
		do
			log.enter ("on_end_document")
			log.exit
		end

	on_start_tag
			--
		do
			log.enter_with_args ("on_start_tag", << last_node_name >>)
			name_stack.extend (last_node_name.string)
			from attribute_list.start until attribute_list.after loop
				log.put_string_field (attribute_list.node.xpath_name, attribute_list.node.to_string)
				log.put_new_line
				attribute_list.forth
			end
			log.exit
		end

	on_end_tag
			--
		do
			log.enter ("on_end_tag")
			log.put_line (name_stack.item)
			name_stack.remove
			log.exit
		end

	on_content
			--
		do
			log.enter ("on_content")
			log.put_line (last_node_text)
			log.exit
		end

	on_comment
			--
		do
			log.enter ("on_comment")
			log.exit
		end

	on_processing_instruction
			--
		do
			log.enter ("on_processing_instruction")
			log.exit
		end

feature {NONE} -- Implementation

	create_parse_event_source: EL_XML_PARSE_EVENT_SOURCE
			--
		do
			create {EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE} Result.make (Current)
		end

	name_stack: ARRAYED_STACK [STRING]

end
