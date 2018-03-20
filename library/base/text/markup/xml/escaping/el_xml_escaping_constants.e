note
	description: "Summary description for {EL_XML_ESCAPING_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-14 9:34:14 GMT (Wednesday 14th March 2018)"
	revision: "3"

class
	EL_XML_ESCAPING_CONSTANTS

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

	Attribute_escaper: EL_XML_ATTRIBUTE_VALUE_ESCAPER [ZSTRING]
		once
			create Result.make
		end

	Attribute_128_plus_escaper: EL_XML_ATTRIBUTE_VALUE_ESCAPER [ZSTRING]
		once
			create Result.make_128_plus
		end

	Xml_escaper: EL_XML_CHARACTER_ESCAPER [ZSTRING]
		once
			create Result.make
		end

	Xml_128_plus_escaper: EL_XML_CHARACTER_ESCAPER [ZSTRING]
		once
			create Result.make_128_plus
		end

end
