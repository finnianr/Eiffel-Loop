note
	description: "Summary description for {EL_UTF8_XML_NODE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_UTF8_XML_NODE

inherit
	EL_XML_NODE
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			Precursor
			create text.make_empty
		end

feature -- Element change

	set_text (a_text: like text)
			--
		do
			text := a_text
		end

feature {NONE} -- Implementation

	text: STRING

end
