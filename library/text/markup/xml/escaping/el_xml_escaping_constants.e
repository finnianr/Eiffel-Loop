note
	description: "Summary description for {EL_XML_ESCAPING_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 13:02:08 GMT (Wednesday 16th December 2015)"
	revision: "7"

class
	EL_XML_ESCAPING_CONSTANTS

feature -- Constants

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
