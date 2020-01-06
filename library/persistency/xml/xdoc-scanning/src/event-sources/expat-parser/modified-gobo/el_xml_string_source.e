note
	description: "Strings as source of XML documents"
	library: "Gobo Eiffel XML Library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
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
