note
	description: "Summary description for {EL_XML_DOCUMENT_LOGGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_XML_DOCUMENT_LOGGER

inherit
	EL_XML_DOCUMENT_SCANNER
		redefine
			make_last_node
		end

	EL_EIF_OBJ_XPATH_CONTEXT
		rename
			make as make_context
		end

	EL_MODULE_STRING
		export
			{NONE} all
		end

	EL_MODULE_LOG

create
	make_pyxis_source

feature {NONE} -- Initialization

	make_last_node
			--
		do
			Precursor
			make_context
		end

feature -- Basic operations

	do_with_xpath
			--
		do
		end

feature {NONE} -- Parsing events

	on_xml_tag_declaration
			--
		do
			log.enter ("on_xml_tag_declaration")
			log.put_real_field ("version", xml_version)
			log.put_string_field (" encoding", encoding_name)
			log.put_new_line
			log.exit
		end

	on_start_document
			--
		do
			log_or_io.put_line ("Document start")
		end

	on_end_document
			--
		do
			log_or_io.put_line ("Document end")
		end

	on_start_tag
			--
		local
			i: INTEGER
			attribute_node: EL_XML_ATTRIBUTE_NODE
		do
			log.enter ("on_start_tag")
			add_xpath_step (last_node.xpath_name)
			log_or_io.put_line (xpath)
			from i := 1  until i > attribute_list.count loop
				attribute_node := attribute_list [i]
				add_xpath_step (attribute_node.xpath_name)
				log.put_string_field (xpath, attribute_node.to_string)
				log.put_new_line
				remove_xpath_step
				i := i + 1
			end
			log.exit
		end

	on_end_tag
			--
		do
			log.enter ("on_end_tag")
			remove_xpath_step
			log_or_io.put_line (xpath)
			log.exit
		end

	on_content
			--
		do
			log.enter ("on_content")
			add_xpath_step (last_node.xpath_name)
			log_or_io.put_line (xpath)
			log_or_io.put_string_field_to_max_length ("CONTENT", last_node_text, 120)
			remove_xpath_step
			log.exit
		end

	on_comment
			--
		do
			log.enter ("on_comment")
			add_xpath_step (last_node.xpath_name)
			log_or_io.put_line (xpath)
			log_or_io.put_line ( last_node_text)
			remove_xpath_step
			log.exit
		end

	on_processing_instruction
			--
		do
		end

end
