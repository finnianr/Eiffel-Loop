note
	description: "Summary description for {EL_XML_ATTRIBUTE_VALUE_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-03 13:46:53 GMT (Tuesday 3rd April 2018)"
	revision: "3"

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
