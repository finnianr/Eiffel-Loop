note
	description: "Xml document logger"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-07 16:28:07 GMT (Thursday 7th December 2023)"
	revision: "13"

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
			lio.put_real_field ("version", version, Void)
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
			i: INTEGER
		do
			lio.put_line ("on_start_tag")
			extend_xpath (last_node)
			lio.put_line (xpath)
			if attached attribute_list.area as area and then area.count > 0 then
				from until i = area.count loop
					if attached area [i] as attribute_node then
						extend_xpath (attribute_node)
						lio.put_string_field (xpath, attribute_node.to_string)
						lio.put_new_line
						remove_xpath_step
					end
					i := i + 1
				end
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

	on_content (a_node: EL_DOCUMENT_NODE_STRING)
			--
		do
			lio.put_line ("on_content")
			extend_xpath (a_node)
			lio.put_line (xpath)
			lio.put_curtailed_string_field ("CONTENT", a_node.adjusted (False), 120)
			remove_xpath_step
			lio.put_new_line
		end

	on_comment
			--
		do
			lio.put_line ("on_comment")
			extend_xpath (last_node)
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