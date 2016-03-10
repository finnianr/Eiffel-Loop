note
	description: "Strings as source of XML documents"

	library: "Gobo Eiffel XML Library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class EL_XML_STRING_SOURCE

inherit

	EL_XML_SOURCE

feature -- Output

	out: STRING
			-- Textual representation
		once
			Result := "STRING"
		end
	
end

