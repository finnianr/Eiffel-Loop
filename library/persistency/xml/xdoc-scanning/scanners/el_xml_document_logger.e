note
	description: "Summary description for {EL_XML_DOCUMENT_LOGGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 20:13:13 GMT (Friday 8th July 2016)"
	revision: "4"

class
	EL_XML_DOCUMENT_LOGGER

inherit
	EL_XML_DOCUMENT_SCANNER
		redefine
			make_default
		end

	EL_EIF_OBJ_XPATH_CONTEXT
		redefine
			make_default
		end

	EL_MODULE_LIO

create
	make_pyxis_source

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_XML_DOCUMENT_SCANNER}
			Precursor {EL_EIF_OBJ_XPATH_CONTEXT}
		end

feature -- Basic operations

	do_with_xpath
			--
		do
		end

feature {NONE} -- Parsing events

	on_xml_tag_declaration (version: REAL; encodeable: EL_ENCODEABLE_AS_TEXT)
			--
		do
--			lio.put_line ("on_xml_tag_declaration")
--			lio.put_real_field ("version", version)
--			lio.put_string_field (" encoding", encodeable.encoding_name)
--			lio.put_new_line
--			lio.put_new_line
		end

	on_start_document
			--
		do
--			lio.put_line ("Document start")
		end

	on_end_document
			--
		do
--			lio.put_line ("Document end")
		end

	on_start_tag
			--
		local
			i: INTEGER; attribute_node: EL_XML_ATTRIBUTE_NODE
		do
--			lio.put_line ("on_start_tag")
			add_xpath_step (last_node.xpath_name)
--			lio.put_line (xpath)
			from i := 1  until i > attribute_list.count loop
				attribute_node := attribute_list [i]
				add_xpath_step (attribute_node.xpath_name)
--				lio.put_string_field (xpath, attribute_node.to_string)
--				lio.put_new_line
				remove_xpath_step
				i := i + 1
			end
--			lio.put_new_line
		end

	on_end_tag
			--
		do
--			lio.put_line ("on_end_tag")
			remove_xpath_step
--			lio.put_line (xpath)
--			lio.put_new_line
		end

	on_content
			--
		do
--			lio.put_line ("on_content")
			add_xpath_step (last_node.xpath_name)
--			lio.put_line (xpath)
--			lio.put_string_field_to_max_length ("CONTENT", last_node_text, 120)
			remove_xpath_step
--			lio.put_new_line
		end

	on_comment
			--
		do
--			lio.put_line ("on_comment")
			add_xpath_step (last_node.xpath_name)
--			lio.put_line (xpath)
--			lio.put_line ( last_node_text)
			remove_xpath_step
--			lio.put_new_line
		end

	on_processing_instruction
			--
		do
		end

end
