note
	description: "Binary encoded XML document scanner"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-13 13:17:35 GMT (Sunday 13th August 2023)"
	revision: "14"

class
	EL_BINARY_ENCODED_DOCUMENT_SCANNER

inherit
	EL_DOCUMENT_NODE_SCANNER
		undefine
			new_lio
		redefine
			make_default, on_meta_data, on_start_document, on_end_document,
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

	on_meta_data (version: REAL; a_encoding: EL_ENCODING_BASE)
			--
		do
			if is_lio_enabled then
				lio.put_substitution ("version = %S, encoding = %S", [version, a_encoding.name])
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
		local
			i: INTEGER
		do
			if is_lio_enabled then
				Lio.put_labeled_string ("on_start_tag", last_node_name)
				lio.put_new_line
			end
			name_stack.extend (last_node_name.string)
			if is_lio_enabled and then attached attribute_list.area as area
				and then area.count > 0
			then
				from until i = area.count loop
					if attached area [i] as node then
						lio.put_string_field (node.xpath_name (False), node.adjusted (False))
						lio.put_new_line
					end
					i := i + 1
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

	on_content (node: EL_DOCUMENT_NODE_STRING)
			--
		do
			if is_lio_enabled then
				lio.put_labeled_string ("on_content", node.adjusted (False))
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

	name_stack: ARRAYED_STACK [STRING]

end