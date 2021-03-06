note
	description: "Xml document logger"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-16 12:51:18 GMT (Saturday 16th January 2021)"
	revision: "8"

class
	EL_DOCUMENT_NODE_LOGGER

inherit
	EL_DOCUMENT_NODE_SCANNER
		redefine
			make_default, on_meta_data
		end

	EL_EIF_OBJ_XPATH_CONTEXT
		redefine
			make_default
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_DOCUMENT_NODE_SCANNER}
			Precursor {EL_EIF_OBJ_XPATH_CONTEXT}
		end

feature -- Basic operations

	do_with_xpath
			--
		do
		end

feature {NONE} -- Parsing events

	on_meta_data (version: REAL; a_encoding: EL_ENCODING_BASE)
			--
		do
			Precursor (version, a_encoding)
			lio.put_line ("on_meta_data")
			lio.put_real_field ("version", version)
			lio.put_string_field (" encoding", a_encoding.name)
			lio.put_new_line
			lio.put_new_line
		end

	on_start_document
			--
		do
			lio.put_line ("Document start")
		end

	on_end_document
			--
		do
			lio.put_line ("Document end")
		end

	on_start_tag
			--
		local
			i: INTEGER; attribute_node: EL_ELEMENT_ATTRIBUTE_NODE_STRING
		do
			lio.put_line ("on_start_tag")
			add_xpath_step (last_node.xpath_name (False))
			lio.put_line (xpath)
			from i := 1  until i > attribute_list.count loop
				attribute_node := attribute_list [i]
				add_xpath_step (attribute_node.xpath_name (False))
				lio.put_string_field (xpath, attribute_node.to_string)
				lio.put_new_line
				remove_xpath_step
				i := i + 1
			end
			lio.put_new_line
		end

	on_end_tag
			--
		do
			lio.put_line ("on_end_tag")
			remove_xpath_step
			lio.put_line (xpath)
			lio.put_new_line
		end

	on_content
			--
		do
			lio.put_line ("on_content")
			add_xpath_step (last_node.xpath_name (False))
			lio.put_line (xpath)
			lio.put_string_field_to_max_length ("CONTENT", last_node.adjusted (False), 120)
			remove_xpath_step
			lio.put_new_line
		end

	on_comment
			--
		do
			lio.put_line ("on_comment")
			add_xpath_step (last_node.xpath_name (False))
			lio.put_line (xpath)
			lio.put_line (last_node.adjusted (False))
			remove_xpath_step
			lio.put_new_line
		end

	on_processing_instruction
			--
		do
		end

end