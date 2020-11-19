note
	description: "Current version info for downloadable software"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-19 13:43:28 GMT (Thursday 19th November 2020)"
	revision: "2"

class
	EL_SOFTWARE_VERSION_INFO_SERVLET

inherit
	FCGI_HTTP_SERVLET
		rename
			make as make_servlet
		end

create
	make

feature {NONE} -- Initialization

	make (a_servlet_config: like servlet_config; software_version: EL_CURRENT_SOFTWARE_VERSION)
		do
			make_servlet (a_servlet_config)
			create version_info.make (software_version)
		end

feature {NONE} -- Implementation

	serve (request: like new_request; response: like new_response)
			--
		do
			log.enter ("serve")
			log.put_labeled_string ("IP", request.parameters.remote_addr)
			response.set_content (version_info.to_utf_8_xml, Doc_type_xml_utf_8)
			log.exit
		end

feature {NONE} -- Internal attributes

	version_info: EL_SOFTWARE_VERSION_INFO
end