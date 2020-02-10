note
	description: "Binary encoded XML document scanner"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-10 14:19:45 GMT (Monday 10th February 2020)"
	revision: "7"

class
	EL_BINARY_ENCODED_XML_DOCUMENT_SCANNER

inherit
	EL_XML_DOCUMENT_SCANNER
		undefine
			new_lio
		redefine
			make_default, on_xml_tag_declaration, on_start_document, on_end_document,
			on_start_tag, on_end_tag, on_content, on_comment, on_processing_instruction
		end

	EL_MODULE_LIO

create
	make

feature {NONE}  -- Initialisation

	make_default
			--
		do
			Precursor
			create name_stack.make (7)
		end

feature {NONE} -- Parsing events

	on_xml_tag_declaration (version: REAL; encodeable: EL_ENCODEABLE_AS_TEXT)
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_xml_tag_declaration")
			end
		end

	on_start_document
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_start_document")
			end
		end

	on_end_document
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_end_document")
			end
		end

	on_start_tag
			--
		do
			if is_lio_enabled then
				Lio.put_labeled_string ("on_start_tag", last_node_name)
				lio.put_new_line
			end
			name_stack.extend (last_node_name.string)
			if is_lio_enabled then
				from attribute_list.start until attribute_list.after loop
					lio.put_string_field (attribute_list.node.xpath_name, attribute_list.node.to_string)
					lio.put_new_line
					attribute_list.forth
				end
			end
		end

	on_end_tag
			--
		do
			if is_lio_enabled then
				lio.put_labeled_string ("on_end_tag", name_stack.item)
				lio.put_new_line
			end
			name_stack.remove
		end

	on_content
			--
		do
			if is_lio_enabled then
				lio.put_labeled_string ("on_content", last_node_text)
				lio.put_new_line
			end
		end

	on_comment
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_comment")
			end
		end

	on_processing_instruction
			--
		do
			if is_lio_enabled then
				lio.put_line ("on_processing_instruction")
			end
		end

feature {NONE} -- Implementation

	create_parse_event_source: EL_PARSE_EVENT_SOURCE
			--
		do
			create {EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE} Result.make (Current)
		end

	name_stack: ARRAYED_STACK [STRING]

end
