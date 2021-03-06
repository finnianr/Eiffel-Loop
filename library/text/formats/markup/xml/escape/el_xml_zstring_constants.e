note
	description: "XML [$source EL_ZSTRING] constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-11 13:52:38 GMT (Monday 11th January 2021)"
	revision: "10"

deferred class
	EL_XML_ZSTRING_CONSTANTS

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

	Attribute_escaper: EL_XML_ATTRIBUTE_VALUE_ZSTRING_ESCAPER
		once
			create Result.make
		end

	Attribute_128_plus_escaper: EL_XML_ATTRIBUTE_VALUE_ZSTRING_ESCAPER
		once
			create Result.make_128_plus
		end

	Xml_escaper: EL_XML_ZSTRING_ESCAPER
		once
			create Result.make
		end

	Xml_128_plus_escaper: EL_XML_ZSTRING_ESCAPER
		once
			create Result.make_128_plus
		end

end