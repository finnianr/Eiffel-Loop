note
	description: "Summary description for {EL_XML_TEXT_NODE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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