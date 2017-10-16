note
	description: "Summary description for {EL_UTF8_XML_NODE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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