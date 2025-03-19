note
	description: "Evolicity xml value"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:04:29 GMT (Tuesday 18th March 2025)"
	revision: "6"

deferred class
	EVC_XML_VALUE

inherit
	EVC_SERIALIZEABLE_AS_XML
		undefine
			to_xml
		end

feature {NONE} -- Implementation

	XML_template: STRING = ""

end