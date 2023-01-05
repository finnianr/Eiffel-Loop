note
	description: "XML [$source ZSTRING] constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 11:12:30 GMT (Thursday 5th January 2023)"
	revision: "14"

deferred class
	XML_ZSTRING_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Header_template: ZSTRING
		once
			Result := "[
				<?xml version="#" encoding="#"?>
			]"
		end

	Close_tag_marker: ZSTRING
		once
			Result := "</"
		end

	Empty_tag_marker: ZSTRING
		once
			Result := "/>"
		end

	Sign_less_than: ZSTRING
		once
			Result := "<"
		end

	Sign_greater_than: ZSTRING
		once
			Result := ">"
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