note
	description: "Xml string 32 escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_XML_STRING_32_ESCAPER

inherit
	EL_XML_GENERAL_ESCAPER

	EL_STRING_32_ESCAPER
		rename
			make as make_escaper
		undefine
			append_escape_sequence, is_escaped
		end

create
	make, make_128_plus

end
