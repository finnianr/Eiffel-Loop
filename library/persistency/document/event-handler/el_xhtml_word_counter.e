note
	description: "XHTML word counter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-02 18:57:55 GMT (Friday 2nd May 2025)"
	revision: "17"

class
	EL_XHTML_WORD_COUNTER

inherit
	EL_DOCUMENT_PARSE_EVENT_HANDLER

	EL_READABLE_STRING_GENERAL_ROUTINES_I
		export
			{NONE} all
		end

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
			count := count + word_count (node.adjusted (False), True)
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
					count := count + word_count (l_attribute.item.adjusted (False), True)
				end
			end
		end

feature {NONE} -- Constants

	Text_attributes: ARRAY [EL_UTF_8_STRING]
		once
			Result := << "alt", "title" >>
			Result.compare_objects
		end

end