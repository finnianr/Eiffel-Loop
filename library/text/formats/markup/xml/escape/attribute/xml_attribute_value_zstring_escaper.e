note
	description: "XML [$source ZSTRING] attribute value escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-22 10:00:06 GMT (Wednesday 22nd June 2022)"
	revision: "7"

class
	XML_ATTRIBUTE_VALUE_ZSTRING_ESCAPER

inherit
	XML_ATTRIBUTE_VALUE_GENERAL_ESCAPER

	EL_ZSTRING_ESCAPER
		rename
			make as make_escaper
		undefine
			append_escape_sequence, is_escaped
		end

create
	make, make_128_plus

end