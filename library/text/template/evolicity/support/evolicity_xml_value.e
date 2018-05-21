note
	description: "Evolicity xml value"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:06 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EVOLICITY_XML_VALUE

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		undefine
			to_xml
		end

feature {NONE} -- Implementation

	XML_template: STRING = ""

end