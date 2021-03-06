note
	description: "XML [$source STRING_8] constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 17:56:59 GMT (Tuesday 2nd March 2021)"
	revision: "2"

deferred class
	EL_XML_STRING_8_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Header_template: EL_TEMPLATE [STRING_8]
		once
			create Result.make ("[
				<?xml version="$version" encoding="$encoding"?>
			]")
		end

	Comment_close: STRING_8 = "-->"

	Comment_open: STRING_8 = "<!--"

	Close_tag_marker: STRING_8 = "</"

	Empty_tag_marker: STRING_8 = "/>"

	Left_angle_bracket: STRING_8 = "<"

	Right_angle_bracket: STRING_8 = ">"

	Var_version: STRING = "version"

	Var_encoding: STRING = "encoding"

feature {NONE} -- Escaping

	Attribute_escaper: EL_XML_ATTRIBUTE_VALUE_STRING_8_ESCAPER
		once
			create Result.make
		end

	Attribute_128_plus_escaper: EL_XML_ATTRIBUTE_VALUE_STRING_8_ESCAPER
		once
			create Result.make_128_plus
		end

	Xml_escaper: EL_XML_STRING_8_ESCAPER
		once
			create Result.make
		end

	Xml_128_plus_escaper: EL_XML_STRING_8_ESCAPER
		once
			create Result.make_128_plus
		end

end