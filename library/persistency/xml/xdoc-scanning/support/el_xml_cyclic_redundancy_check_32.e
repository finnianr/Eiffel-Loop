note
	description: "Xml cyclic redundancy check 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_XML_CYCLIC_REDUNDANCY_CHECK_32

inherit
	EL_XML_NODE_EVENT_HANDLER

	EL_CYCLIC_REDUNDANCY_CHECK_32

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