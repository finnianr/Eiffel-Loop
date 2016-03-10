note
	description: "Summary description for {EL_XML_ESCAPING_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_XML_ESCAPING_CONSTANTS

feature -- Constants

	Attribute_escaper: EL_XML_ATTRIBUTE_VALUE_ESCAPER
		once
			create Result.make
		end

	Attribute_128_plus_escaper: EL_XML_ATTRIBUTE_VALUE_ESCAPER
		once
			create Result.make_128_plus
		end

	Xml_escaper: EL_XML_CHARACTER_ESCAPER
		once
			create Result.make
		end

	Xml_128_plus_escaper: EL_XML_CHARACTER_ESCAPER
		once
			create Result.make_128_plus
		end

end
