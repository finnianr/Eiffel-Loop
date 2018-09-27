note
	description: "Xml attribute value general escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "6"

deferred class
	EL_XML_ATTRIBUTE_VALUE_GENERAL_ESCAPER

inherit
	EL_XML_GENERAL_ESCAPER
		redefine
			make
		end

feature {NONE} -- Initialization

	make
		do
			Precursor
			extend_entities ('"', "quot")
		end

end
