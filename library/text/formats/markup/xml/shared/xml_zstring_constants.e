note
	description: "XML ${ZSTRING} constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 9:15:05 GMT (Saturday 22nd March 2025)"
	revision: "18"

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

	Xml_128_plus_escaper: XML_ESCAPER [ZSTRING]
		once
			create Result.make_128_plus
		end

	XML_escaper: XML_ESCAPER [ZSTRING]
		once
			create Result.make
		end

end