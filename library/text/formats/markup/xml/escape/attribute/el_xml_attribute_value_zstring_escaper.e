note
	description: "Xml [$source EL_ZSTRING] attribute value escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-11 13:55:17 GMT (Monday 11th January 2021)"
	revision: "5"

class
	EL_XML_ATTRIBUTE_VALUE_ZSTRING_ESCAPER

inherit
	EL_XML_ATTRIBUTE_VALUE_GENERAL_ESCAPER

	EL_ZSTRING_ESCAPER
		rename
			make as make_escaper
		undefine
			append_escape_sequence, is_escaped
		end

create
	make, make_128_plus

end