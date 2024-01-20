note
	description: "XML ${ZSTRING} constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "17"

deferred class
	XML_ZSTRING_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Header_template: ZSTRING
		once
			Result := "[
				<?xml version="#" encoding="#"?>
			]"
		end

	Bracket: TUPLE [left, left_comment, left_slash, right, right_comment, slash_right: ZSTRING]
		-- angle bracket markers
		once
			create Result
			Tuple.fill (Result, "<, <!--, </, >, -->, />")
		end

feature {NONE} -- Escaping

	Xml_escaper: XML_ESCAPER [ZSTRING]
		once
			create Result.make
		end

	Xml_128_plus_escaper: XML_ESCAPER [ZSTRING]
		once
			create Result.make_128_plus
		end

end