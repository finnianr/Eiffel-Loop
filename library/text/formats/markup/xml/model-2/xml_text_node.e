note
	description: "Xml text node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:56 GMT (Friday 10th March 2023)"
	revision: "8"

class
	XML_TEXT_NODE

inherit
	XML_ELEMENT

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