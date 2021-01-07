note
	description: "Xhtml word counter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-07 11:54:42 GMT (Thursday 7th January 2021)"
	revision: "8"

class
	EL_XHTML_WORD_COUNTER

inherit
	EL_DOCUMENT_PARSE_EVENT_HANDLER


feature -- Access

	count: INTEGER

feature {NONE} -- Event handlers

	on_comment (node: EL_DOCUMENT_NODE_STRING)
			--
		do
		end

	on_content (node: EL_DOCUMENT_NODE_STRING)
			--
		do
			count := count + word_count (node.to_string_32)
		end

	on_end_document
			--
		do
		end

	on_end_tag (node: EL_DOCUMENT_NODE_STRING)
			--
		do
		end

	on_processing_instruction (node: EL_DOCUMENT_NODE_STRING)
			--
		do
		end

	on_start_document
			--
		do
		end

	on_start_tag (node: EL_DOCUMENT_NODE_STRING; attribute_list: EL_ELEMENT_ATTRIBUTE_LIST)
			--
		local
			name: EL_UTF_8_STRING
		do
			across attribute_list as l_attribute loop
				name := l_attribute.item.raw_name
				if Text_attributes.has (name)  then
					count := count + word_count (l_attribute.item.adjusted_32 (False))
				end
			end
		end

feature {NONE} -- Implementation

	word_count (str: STRING_32): INTEGER
		local
			s: EL_STRING_32_ROUTINES
		do
			Result := s.word_count (str)
		end

feature {NONE} -- Constants

	Text_attributes: ARRAY [EL_UTF_8_STRING]
		once
			Result := << "alt", "title" >>
			Result.compare_objects
		end

end