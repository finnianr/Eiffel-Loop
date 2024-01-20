note
	description: "XML ${STRING_8} constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "12"

deferred class
	XML_STRING_8_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Bracket: TUPLE [left, left_comment, left_slash, right, right_comment, slash_right: STRING_8]
		-- angle bracket markers
		once
			create Result
			Tuple.fill (Result, "<, <!--, </, >, -->, />")
		ensure
			not_immutable: not Result.left.is_immutable -- Tried before
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