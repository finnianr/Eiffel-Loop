note
	description: "XML [$source ZSTRING] constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-11 17:05:59 GMT (Monday 11th December 2023)"
	revision: "16"

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