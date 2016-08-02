note
	description: "[
		XML generator that does not split text nodes on new line character.
		Tabs and new lines in from text content are escaped.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 18:48:40 GMT (Wednesday 16th December 2015)"
	revision: "1"

class
	EL_PYXIS_XML_TEXT_GENERATOR

inherit
	EL_XML_TEXT_GENERATOR
		rename
			make as make_xml_source,
			make_pyxis_source as make
		redefine
			xml_escaper
		end

create
	make

feature {NONE} -- Constants

	xml_escaper: EL_XML_CHARACTER_ESCAPER [ZSTRING]
		once
			create Result.make
			Result.extend ('%T')
		end

end