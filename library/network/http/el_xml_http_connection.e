note
	description: "Summary description for {EL_XML_HTTP_CONNECTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-20 14:30:16 GMT (Wednesday 20th May 2015)"
	revision: "5"

class
	EL_XML_HTTP_CONNECTION

inherit
	EL_HTTP_CONNECTION
		rename
			make as make_http,
			read_string as read_xml
		redefine
			read_xml
		end

create
	make, make_with_default

feature {NONE} -- Initialization

	make
		do
			make_with_default (create {EL_DEFAULT_SERIALIZEABLE_XML})
		end

	make_with_default (a_default_document: like default_document)
		do
			make_http
			create root_node
			default_document := a_default_document
		end

feature -- Access

	root_node: EL_XPATH_ROOT_NODE_CONTEXT

feature -- Status query

	is_default_xml: BOOLEAN
		do
			root_node.find_node ("/default")
			Result := root_node.node_found
		end

feature -- Basic operations

	read_xml
		do
			Precursor
			if has_error or else has_some_http_error or else not last_string.starts_with ("<?xml") then
				on_not_xml_read
			else
				on_xml_read
			end
			create root_node.make_from_string (last_string)
		end

feature {NONE} -- Event handling

	on_not_xml_read
		do
			last_string := default_document.to_utf_8_xml
		end

	on_xml_read
		do
		end

feature {NONE} -- Implementation

	default_document: EL_SERIALIZEABLE_AS_XML

end
