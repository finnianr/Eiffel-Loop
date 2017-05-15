note
	description: "[
		XML generator that does not split text nodes on new line character.
		Tabs and new lines in from text content are escaped.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-12 12:04:09 GMT (Friday 12th May 2017)"
	revision: "2"

class
	EL_PYXIS_XML_TEXT_GENERATOR

inherit
	EL_XML_TEXT_GENERATOR

		rename
			make as make_generator
		redefine
			xml_escaper
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_generator ({EL_PYXIS_PARSER})
		end

feature {NONE} -- Constants

	xml_escaper: EL_XML_CHARACTER_ESCAPER [ZSTRING]
		once
			create Result.make
			Result.extend ('%T')
		end

end
