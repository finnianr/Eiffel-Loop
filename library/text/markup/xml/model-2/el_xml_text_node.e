note
	description: "Summary description for {EL_XML_TEXT_NODE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 8:09:27 GMT (Wednesday 16th December 2015)"
	revision: "3"

class
	EL_XML_TEXT_NODE

inherit
	EL_XML_ELEMENT

create
	make

convert
 make ({ZSTRING})

feature {NONE} -- Initialization

	make (a_text: like text)
		do
			text := a_text
		end

feature -- Access

	name: ZSTRING
		do
			Result := "text()"
		end

	text: ZSTRING

feature -- Basic operations

	write (medium: EL_OUTPUT_MEDIUM)
		do
			medium.put_string (text)
		end

end
