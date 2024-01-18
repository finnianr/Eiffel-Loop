note
	description: "XML ${STRING_8} constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-20 16:50:10 GMT (Wednesday 20th December 2023)"
	revision: "11"

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