note
	description: "Summary description for {EL_XML_ATTRIBUTE_VALUE_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_XML_ATTRIBUTE_VALUE_ESCAPER [S -> STRING_GENERAL create make end]

inherit
	EL_XML_CHARACTER_ESCAPER [S]
		redefine
			make
		end

create
	make, make_128_plus

feature {NONE} -- Initialization

	make
		do
			Precursor
			extend_entities ('"', "quot")
		end

end