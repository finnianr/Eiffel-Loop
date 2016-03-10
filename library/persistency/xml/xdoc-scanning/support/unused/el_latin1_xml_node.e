note
	description: "Summary description for {EL_LATIN1_XML_NODE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_LATIN1_XML_NODE

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

	-- text: EL_LATIN1_STRING_8
	text: STRING_8

end
