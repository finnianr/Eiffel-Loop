note
	description: "XML HTTP connection"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-07 14:53:51 GMT (Thursday 7th September 2023)"
	revision: "15"

class
	EL_XML_HTTP_CONNECTION

inherit
	EL_HTTP_CONNECTION
		rename
			make as make_http,
			read_string_get as read_xml_get,
			read_string_post as read_xml_post
		redefine
			do_command
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_default (create {EL_DEFAULT_SERIALIZEABLE_XML})
		end

	make_with_default (a_default_document: like default_document)
		do
			make_http
			create xdoc.make_from_string (a_default_document.to_xml)
			default_document := a_default_document
		end

feature -- Access

	xdoc: EL_XML_DOC_CONTEXT

feature -- Status query

	is_default_xml: BOOLEAN
		do
			Result := attached xdoc.find_node ("/default")
		end

feature {NONE} -- Event handling

	on_not_xml_read
		do
			last_string := default_document.to_xml
		end

	on_xml_read
		do
		end

feature {NONE} -- Implementation

	do_command (command: EL_STRING_DOWNLOAD_HTTP_COMMAND)
		do
			Precursor (command)
			if not attached {EL_HEAD_HTTP_COMMAND} command then
				if has_error or else has_some_http_error or else not last_string.starts_with ("<?xml") then
					on_not_xml_read
				else
					on_xml_read
				end
				create xdoc.make_from_string (last_string)
			end
		end

feature {NONE} -- Internal attributes

	default_document: EL_SERIALIZEABLE_AS_XML

end