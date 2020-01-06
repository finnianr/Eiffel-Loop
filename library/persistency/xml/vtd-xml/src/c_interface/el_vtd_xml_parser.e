note
	description: "Vtd xml parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 9:59:55 GMT (Saturday 26th October 2019)"
	revision: "7"

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

feature {EL_XPATH_ROOT_NODE_CONTEXT} -- Access

	root_context_pointer (xml: EL_C_STRING_8; is_namespace_aware: BOOLEAN): POINTER
			--
		do
			c_evx_set_document (self_ptr, xml.base_address, xml.count)
			c_parse (self_ptr, is_namespace_aware)
			Result := c_evx_root_node_context (self_ptr)
		end

end
