note
	description: "Xml text node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "7"

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