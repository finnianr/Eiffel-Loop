note
	description: "Xml attribute value general escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "4"

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
