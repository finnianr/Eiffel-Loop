note
	description: "XML cyclic redundancy check 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-25 11:10:40 GMT (Thursday 25th July 2019)"
	revision: "6"

class
	EL_XML_CYCLIC_REDUNDANCY_CHECK_32

inherit
	EL_CYCLIC_REDUNDANCY_CHECK_32

	EL_XML_NODE_EVENT_HANDLER
		undefine
			copy, default_create, is_equal
		end

feature {EL_XML_NODE_EVENT_GENERATOR} -- Parsing events

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

	on_start_tag (node: EL_XML_NODE; attribute_list: EL_XML_ATTRIBUTE_LIST)
			--
		do
			add_string_32 (node.name)
			across attribute_list as l_attribute loop
				add_string_32 (l_attribute.item.name)
				add_string_32 (l_attribute.item.to_string_32)
			end
		end

	on_end_tag (node: EL_XML_NODE)
			--
		do
			add_integer (222); add_integer (node.type); add_string_32 (node.name)
		end

	on_content, on_comment, on_processing_instruction (node: EL_XML_NODE)
			--
		do
			add_integer (node.type)
			add_string_32 (node.to_string_32)
		end

end
