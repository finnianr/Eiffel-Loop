note
	description: "Summary description for {EL_XML_TEXT_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_XML_TEXT_NODE

inherit
	EL_XML_ELEMENT

create
	make

convert
 make ({ASTRING})

feature {NONE} -- Initialization

	make (a_text: like text)
		do
			text := a_text
		end

feature -- Access

	name: ASTRING
		do
			Result := "text()"
		end

	text: ASTRING

feature -- Basic operations

	write (medium: EL_OUTPUT_MEDIUM)
		do
			medium.put_string (text)
		end

end
