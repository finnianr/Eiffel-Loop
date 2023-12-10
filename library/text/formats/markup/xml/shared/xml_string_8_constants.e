note
	description: "XML [$source STRING_8] constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-10 16:51:42 GMT (Sunday 10th December 2023)"
	revision: "7"

deferred class
	XML_STRING_8_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Comment_close: STRING_8 = "-->"

	Comment_open: STRING_8 = "<!--"

	Close_tag_marker: STRING_8 = "</"

	Empty_tag_marker: STRING_8 = "/>"

	Left_angle_bracket: STRING_8 = "<"

	Right_angle_bracket: STRING_8 = ">"

feature {NONE} -- Escaping

	Xml_escaper: XML_ESCAPER [STRING_8]
		once
			create Result.make
		end

	Xml_128_plus_escaper: XML_ESCAPER [STRING_8]
		once
			create Result.make_128_plus
		end

end