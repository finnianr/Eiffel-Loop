note
	description: "Summary description for {EL_VTD_XML_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_VTD_XML_PARSER

inherit
	EL_C_OBJECT -- VTDGen
		rename
			c_free as c_evx_free_parser
		undefine
			c_evx_free_parser
		redefine
			is_memory_owned
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

	root_context_pointer (xml_document: STRING; is_namespace_aware: BOOLEAN): POINTER
			--
		do
			c_evx_set_document (self_ptr, xml_document.area.base_address, xml_document.count)
			c_parse (self_ptr, is_namespace_aware)
			Result := c_evx_root_node_context (self_ptr)
		end

feature {NONE} -- Implementation

    is_memory_owned: BOOLEAN = true

end
