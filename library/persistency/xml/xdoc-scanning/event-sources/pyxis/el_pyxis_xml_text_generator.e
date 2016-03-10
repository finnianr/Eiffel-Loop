note
	description: "[
		XML generator that does not split text nodes on new line character.
		Tabs and new lines in from text content are escaped.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-03 8:22:43 GMT (Wednesday 3rd July 2013)"
	revision: "4"

class
	EL_PYXIS_XML_TEXT_GENERATOR

inherit
	EL_XML_TEXT_GENERATOR
		rename
			make as make_xml_source,
			make_pyxis_source as make
		redefine
			XML
		end

create
	make

feature {NONE} -- Implementation

	XML: EL_PYXIS_XML_ROUTINES
		once
			create Result
		end

end
