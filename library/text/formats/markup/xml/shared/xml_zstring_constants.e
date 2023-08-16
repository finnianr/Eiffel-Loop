note
	description: "XML [$source ZSTRING] constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 14:41:07 GMT (Wednesday 2nd August 2023)"
	revision: "15"

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

	Bracket: TUPLE [left, left_slash, right, slash_right: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "<, </, >, />")
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