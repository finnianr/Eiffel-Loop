note
	description: "Evolicity xml value"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

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