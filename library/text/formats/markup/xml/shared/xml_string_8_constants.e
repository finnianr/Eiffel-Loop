note
	description: "XML [$source STRING_8] constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-11 17:05:59 GMT (Monday 11th December 2023)"
	revision: "8"

deferred class
	XML_STRING_8_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Bracket: TUPLE [left, left_comment, left_slash, right, right_comment, slash_right: STRING]
		-- angle bracket markers
		once
			create Result
			Tuple.fill (Result, "<, <!--, </, >, -->, />")
		end

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