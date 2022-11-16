note
	description: "XML [$source ZSTRING] constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "13"

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

	Attribute_escaper: XML_ATTRIBUTE_VALUE_ZSTRING_ESCAPER
		once
			create Result.make
		end

	Attribute_128_plus_escaper: XML_ATTRIBUTE_VALUE_ZSTRING_ESCAPER
		once
			create Result.make_128_plus
		end

	Xml_escaper: XML_ZSTRING_ESCAPER
		once
			create Result.make
		end

	Xml_128_plus_escaper: XML_ZSTRING_ESCAPER
		once
			create Result.make_128_plus
		end

end