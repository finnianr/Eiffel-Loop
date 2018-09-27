note
	description: "Xhtml word counter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_XHTML_WORD_COUNTER

inherit
	EL_XML_NODE_EVENT_HANDLER

	EL_MODULE_STRING_32
		export
			{NONE} all
		end

feature -- Access

	count: INTEGER

feature {NONE} -- Event handlers

	on_comment (node: EL_XML_NODE)
			--
		do
		end

	on_content (node: EL_XML_NODE)
			--
		do
			count := count + String_32.word_count (node.to_string_32)
		end

	on_end_document
			--
		do
		end

	on_end_tag (node: EL_XML_NODE)
			--
		do
		end

	on_start_document
			--
		do
		end

	on_start_tag (node: EL_XML_NODE; attribute_list: EL_XML_ATTRIBUTE_LIST)
			--
		local
			name: STRING_32
		do
			across attribute_list as l_attribute loop
				name := l_attribute.item.name
				if Text_attributes.has (name)  then
					count := count + String_32.word_count (l_attribute.item.to_string_32)
				end
			end
		end

	on_processing_instruction (node: EL_XML_NODE)
			--
		do
		end

feature {NONE} -- Constants

	Text_attributes: ARRAY [STRING_32]
		once
			Result := << "alt", "title" >>
			Result.compare_objects
		end

end