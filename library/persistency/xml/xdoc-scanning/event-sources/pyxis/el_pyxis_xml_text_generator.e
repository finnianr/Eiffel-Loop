note
	description: "[
		XML generator that does not split text nodes on new line character.
		Tabs and new lines in from text content are escaped.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-11 13:22:52 GMT (Saturday 11th January 2020)"
	revision: "5"

class
	EL_PYXIS_XML_TEXT_GENERATOR

inherit
	EL_XML_TEXT_GENERATOR
		rename
			make as make_generator
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_generator ({EL_PYXIS_PARSER})
		end

end
