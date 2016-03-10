note
	description: "Strings as source of XML documents"

	library: "Gobo Eiffel XML Library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "3"

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

