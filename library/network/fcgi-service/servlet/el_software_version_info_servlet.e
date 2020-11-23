note
	description: "Current version info for downloadable software"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-23 10:47:32 GMT (Monday 23rd November 2020)"
	revision: "4"

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

	make (a_service: like service; software_version: EL_CURRENT_SOFTWARE_VERSION)
		do
			make_servlet (a_service)
			create version_info.make (software_version)
		end

feature {NONE} -- Implementation

	serve
			--
		do
			log.enter ("serve")
			log.put_labeled_string ("IP", request.parameters.remote_addr)
			response.set_content (version_info.to_xml, Doc_type_xml_utf_8)
			log.exit
		end

feature {NONE} -- Internal attributes

	version_info: EL_SOFTWARE_VERSION_INFO
end