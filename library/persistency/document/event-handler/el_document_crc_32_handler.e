note
	description: "Document cyclic redundancy check 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	EL_DOCUMENT_CRC_32_HANDLER

inherit
	EL_CYCLIC_REDUNDANCY_CHECK_32

	EL_DOCUMENT_PARSE_EVENT_HANDLER
		undefine
			copy, default_create, is_equal
		end

feature {NONE} -- Parsing events

	on_start_document
			--
		do
			add_integer (111)
		end

	on_end_document
			--
		do
			add_integer (999)
		end

	on_start_tag (node: EL_DOCUMENT_NODE_STRING; attribute_list: EL_ELEMENT_ATTRIBUTE_LIST)
			--
		do
			add_string_8 (node.raw_name)
			across attribute_list as l_attribute loop
				add_string_8 (l_attribute.item.raw_name)
				add_string_8 (l_attribute.item)
			end
		end

	on_end_tag (node: EL_DOCUMENT_NODE_STRING)
			--
		do
			add_integer (222); add_integer (node.type); add_string_8 (node.raw_name)
		end

	on_content, on_comment, on_processing_instruction (node: EL_DOCUMENT_NODE_STRING)
			--
		do
			add_integer (node.type)
			add_string_8 (node)
		end

end