note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "1"

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