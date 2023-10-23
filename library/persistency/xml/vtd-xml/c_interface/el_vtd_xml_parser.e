note
	description: "Vtd XML parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-06 8:43:52 GMT (Friday 6th October 2023)"
	revision: "13"

class
	EL_VTD_XML_PARSER

inherit
	EL_OWNED_C_OBJECT -- VTDGen
		rename
			c_free as c_evx_free_parser
		end

	EL_VTD_XML_API
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_from_pointer (c_evx_create_parser)
		end

feature {EL_XML_DOC_CONTEXT} -- Access

	new_root_context (xml: EL_STRING_8_POINTER; is_namespace_aware: BOOLEAN): POINTER
			--
		do
			c_evx_set_document (self_ptr, xml.item, xml.count)
			c_parse (self_ptr, is_namespace_aware)
			Result := c_evx_root_node_context (self_ptr)
		end

end